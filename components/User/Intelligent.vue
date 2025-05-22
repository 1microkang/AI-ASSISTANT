<template>
  <div class="chat-container">
    <h2 style="text-align: center;color:deepskyblue;">AI Assistant System</h2>
    <el-card class="chat" style="margin-top:10px;height: 80vh;border-radius: 15px;border-color: #ccc;">
      <el-card class="main_chat">
        <div v-for="item in messages" :key="item.id" class="message">
          <!-- 用户消息 -->
          <div v-if="item.inputMessage" class="user-message">
            {{ item.inputMessage }}
          </div>

          <!-- AI消息（合并显示流式内容） -->
          <!-- 修改AI消息部分 -->
          <div v-if="item.aiResult !== undefined" class="bot-message"
            :class="{ 'streaming': item.id === currentAIResponse }">
            <!-- 使用v-html和过滤器 -->
            <div class="markdown-content" v-html="renderMarkdown(item.aiResult)"></div>
            <span v-if="item.id === currentAIResponse" class="streaming-cursor">|</span>
          </div>
        </div>
      </el-card>

      <!-- <el-input
        placeholder="Please enter content, for example: I like books about animals, please recommend some for me."
        v-model.trim="inputMessage" :disabled="loading" @keyup.enter.native="sendMessage">
        <el-button slot="append" icon="el-icon-s-promotion" v-loading="loading" @click="sendMessage"
          :disabled="loading"></el-button>
      </el-input> -->
      <el-input placeholder="Please enter content..." v-model="inputMessage" :disabled="loading"
        @keyup.enter.native="sendMessage">
      </el-input>
      <el-input placeholder="Please enter content..." v-model="inputMessage" :disabled="loading"
        @keyup.enter.native="sendMessage">
      </el-input>
    </el-card>
  </div>
</template>

<script>
// 新增导入
import { fetchEventSource } from '@microsoft/fetch-event-source';
import { marked } from 'marked';
import DOMPurify from 'dompurify';
import hljs from 'highlight.js'; // 代码高亮库

// 配置Markdown解析器
marked.setOptions({
  highlight: function (code, lang) {
    return hljs.highlightAuto(code).value;
  },
  breaks: true // 转换换行符
});

export default {
  data() {
    return {
      messages: [],
      inputMessage: "",
      loading: false,
      abortController: null, // 改用AbortController控制请求
      currentAIResponse: null
    }
  },
  methods: {
    renderMarkdown(content) {
      const rawHtml = marked.parse(content || '');
      return DOMPurify.sanitize(rawHtml, {
        ALLOWED_TAGS: [
          'p', 'br', 'code', 'pre', 'blockquote', 'h1', 'h2', 'h3',
          'strong', 'em', 'a', 'ul', 'ol', 'li', 'hr', 'img', 'table',
          'thead', 'tbody', 'tr', 'th', 'td'
        ],
        ALLOWED_ATTR: ['href', 'target', 'src', 'alt']
      });
    },
    async sendMessage() {
      if (this.inputMessage.trim() === "") return;

      // 添加消息的逻辑保持不变
      const userMessage = {
        id: Date.now(),
        inputMessage: this.inputMessage,
        userId: parseInt(sessionStorage.getItem("userId"))
      };
      this.messages.push(userMessage);

      const aiMessage = {
        id: Date.now() + 1,
        aiResult: "",
        userId: userMessage.userId
      };
      this.messages.push(aiMessage);
      this.currentAIResponse = aiMessage.id;

      try {
        this.loading = true;
        // 取消已有请求
        if (this.abortController) {
          this.abortController.abort();
        }

        // 创建新的AbortController
        this.abortController = new AbortController();
        const message = this.inputMessage;
        this.inputMessage = "";

        // 使用fetch-event-source
        await fetchEventSource(`${process.env.VUE_APP_API_BASE}/user/ai_intelligent`, {
          method: 'POST', // 推荐改用POST
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            message: message,
            userId: aiMessage.userId
          }),
          signal: this.abortController.signal,
          async onopen(response) {
            if (response.ok) return;
            throw new Error(`Server error: ${response.status}`);
          },
          onmessage: (event) => {
            try {
              if (event.data) {
                const parsedData = JSON.parse(event.data);
                const responseData = parsedData.data || '';

                const index = this.messages.findIndex(msg => msg.id === this.currentAIResponse);
                if (index !== -1) {
                  // 流式追加内容
                  this.messages[index].aiResult += responseData;

                  // 强制更新视图（关键！）
                  this.$set(this.messages, index, {
                    ...this.messages[index],
                    aiResult: this.messages[index].aiResult
                  });

                  // 自动滚动
                  this.$nextTick(() => {
                    const container = this.$el.querySelector('.main_chat');
                    if (container) {
                      container.scrollTop = container.scrollHeight + 100;
                    }
                  });
                }
              }
            } catch (err) {
              console.error('解析错误:', err);
            }
          },
          onclose: () => {
            this.loading = false;
            this.currentAIResponse = null;
          },
          openWhenHidden: true,
          onerror: (err) => {
            console.error('SSE Error:', err);
            this.loading = false;
            this.currentAIResponse = null;
            throw err; // 重新抛出错误以终止流
          }
        });
      } catch (error) {
        if (error.name !== 'AbortError') {
          console.error('请求异常:', error);
        }
        this.loading = false;
        this.currentAIResponse = null;
      }
    }
  },
  beforeDestroy() {
    if (this.abortController) {
      this.abortController.abort();
    }
  }
}
</script>

<style scoped lang='less'>
.main_chat {
  margin-bottom: 10px;
  height: 70vh;
  background-size: cover;
  background: url(https://xxx.xiaobaitiao.icu/img/icu/202312211243632.jpg) no-repeat 0px 0px;
  border-radius: 10px;
  overflow-y: auto;
}

.message {
  margin: 10px;
  display: flex;
  flex-direction: column;
}

.user-message {
  background-color: #e7f7ff;
  padding: 10px;
  border-radius: 10px;
  align-self: flex-end;
  max-width: 80%;
  margin: 5px 0;
}

.bot-message {
  background-color: #f4f6f8;
  padding: 10px;
  padding-left: 30px;
  border-radius: 10px;
  align-self: flex-start;
  max-width: 80%;
  margin: 5px 0;
  white-space: pre-wrap;



  &.streaming {
    position: relative;
    background-color: #f8f9fa;
    border: 1px solid #e9ecef;
  }

  .streaming-cursor {
    animation: blink 1s steps(5, start) infinite;
    color: #409eff;
  }

}

// 在style部分添加
.markdown-content {
  line-height: 1.6;

  h1,
  h2,
  h3 {
    margin: 1em 0;
    border-bottom: 1px solid #eee;
    padding-bottom: 0.3em;
  }

  p {
    margin: 0.8em 0;
  }

  code {
    background-color: #f3f4f4;
    padding: 0.2em 0.4em;
    border-radius: 3px;
    font-family: Consolas, Monaco, monospace;
  }

  pre {
    background-color: #f8f9fa;
    padding: 1em;
    border-radius: 4px;
    overflow-x: auto;
    margin: 1em 0;

    code {
      background: none;
      padding: 0;
      font-size: 0.9em;
    }
  }

  blockquote {
    border-left: 4px solid #dfe2e5;
    margin: 1em 0;
    padding: 0 1em;
    color: #6a737d;
  }

  table {
    border-collapse: collapse;
    margin: 1em 0;

    th,
    td {
      border: 1px solid #dfe2e5;
      padding: 0.6em 1em;
    }

    th {
      background-color: #f6f8fa;
    }
  }

  img {
    max-width: 100%;
    border-radius: 4px;
  }

  a {
    color: #409eff;
    text-decoration: none;

    &:hover {
      text-decoration: underline;
    }
  }
}

@keyframes blink {
  to {
    visibility: hidden;
  }
}
</style>