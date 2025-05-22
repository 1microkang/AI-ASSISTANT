<template>
  <div class="chat_container" style="height: 100%">
    <div style="
        height: 100%;
        width: 100%;
        background-color: red;
      ">
      <el-row style="height: 100%">
        <el-col :span="5" style="background-color: grey; height: inherit">
          <div>
            <!--            <div style="position: relative; top: 10px; left: 20px; width: 90%">-->
            <!--              <el-input class="search_input" placeholder="Search"></el-input>-->
            <!--            </div>-->
            <el-row style="height: 60px;background-color:rgb(240, 197, 168);border: 1px solid #eee"
              v-for="item in friendList" key="item.username">
              <el-col :span="6">
                <el-avatar src="https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png" :size="35"
                  style="margin: 10px 30px">
                </el-avatar>
              </el-col>
              <el-col :span="18">
                <el-row>
                  <el-col :span="14">
                    <div style="margin:10px 0px 5px 0px">{{ item.username }}</div>
                    <div class="ellipsis">{{ item.text }}</div>
                  </el-col>
                  <el-col :span="10">
                    <div style="font-size: 10px;margin:10px 0px">
                      {{ item.date }}
                    </div>
                  </el-col>
                </el-row>
              </el-col>
            </el-row>
          </div>
        </el-col>
        <el-col :span="19" style="background-color: blue; height: inherit">
          <div style="background-color: yellowgreen; height: 600px;">
            <el-row style="height: 60px;background-color:red;display: flex;align-items: center;">
              <el-row style="margin-left: 20px;color:rgb(88, 88, 88);font-size:24px">
                Wang Erli
              </el-row>
            </el-row>
            <el-row>
              <el-row v-for="message in messages" :key="message.id"
                :class="{ 'left-message': message.role === 'user', 'right-message': message.role === 'me' }">
                <!-- Single line message including avatar and content -->
                <el-row style="float:left;">
                  <div style="display: flex; align-items: center;">
                    <el-avatar v-if="message.role === 'user'"
                      src="https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png" :size="35"></el-avatar>
                    <p :class="{ 'message-backgroudcolor': true, 'left-message-content': message.role === 'user', 'right-message-content': message.role === 'me' }"
                      v-if="message.role === 'user'"> {{ message.content }}</p>
                  </div>
                </el-row>

                <el-row style="float: right;margin-top:10px">
                  <div style="display: flex; align-items: center;">
                    <span
                      :class="{ 'message-backgroudcolor': true, 'left-message-content': message.role === 'user', 'right-message-content': message.role === 'me' }"
                      v-if="message.role === 'me'"> {{ message.content }}</span>
                    <el-avatar v-if="message.role === 'me'"
                      src="https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png" :size="35"></el-avatar>
                  </div>
                </el-row>
              </el-row>
            </el-row>
          </div>
          <!-- Chat input area -->
          <el-row style="background-color:purple; height: 150px;box-sizing: border-box">
            <el-row style="height: 30px;background-color:red;display: flex; align-items: center;">
              <div style="margin-left: 20px">
                <span>Emoji</span>
                <span style="margin-left: 20px">File</span>
              </div>
            </el-row>
            <el-row style="height: 200px">
              <el-input type="textarea" :autosize="{ minRows: 5, maxRows: 5 }">
              </el-input>
            </el-row>
          </el-row>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script>
// Import socket object
import { socket } from "@/components/Utils/websocket";

export default {
  data() {
    return {
      loading: true,
      websocketCount: -1,
      // Query conditions
      queryCondition: {
        "toId": 2,
        "text": "Hello",
        "chatType": 1,
        "isAdmin": false
      },
      messages: [
        {
          id: 1, content: "Hello23222222222222222222222222222哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈222222222222222222222222222222222222222222222222222222222222222222", role: "user",
        },
        {
          id: 2, content: "Hello红红火火恍恍惚惚哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈红红火火恍恍惚惚哈哈哈哈哈哈哈哈哈哈哈", role: "me",
        },
        {
          id: 3, content: "Hello23222222222222222222222222222哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈222222222222222222222222222222222222222222222222222222222222222222", role: "user",
        },
        {
          id: 4, content: "Hello", role: "me",
        },
      ],
      friendList: [
        {
          username: "Wang Erli",
          text: "Last message: Hello",
          date: "March 1, 2024"
        },
        {
          username: "Li Zhe",
          text: "Last message: Hello",
          date: "December 24, 2024"
        },
      ],
    };
  },
  created() {
    // Initialize websocket object
    // window.location.host gets IP and port
    // process.env.VUE_APP_WEBSOCKET_BASE_API gets request prefix
    // socket.initWebSocket(`ws://localhost:8889/api/websocket/` + 1923);
    // Bind message receiving method
    // socket.websocket.onmessage = this.websocketOnMessage;
  },
  methods: {
    backgroundColor() {
      return backgroundColor
    },
    init() {
      this.queryCondition.type = "message";
      socket.sendMsg(JSON.stringify(this.queryCondition));
    },
    websocketOnMessage(event) {
      // When initializing the interface, actively send a message to the backend to get data
      this.websocketCount += 1;
      if (this.websocketCount === 0) {
        this.init();
      }
      let info = event.data;
      this.messages.push(info);
      switch (info.type) {
        case "PONG":
          socket.websocketState = true;
          break;
        case "message":
          this.loading = true;
          this.$nextTick(() => {
            this.consumeMessage(info);
          });
          break;
        case "error":
          console.log("Error");
          this.loading = false;
          break;
      }
    },
    consumeMessage(info) {
      // Get the latest data and re-render the interface
      console.log(info);
    },
  },
};
</script>
<style lang="less" scoped>
.chat_container {}

.ellipsis {
  font-size: 12px;
  color: rgb(127, 76, 69);
  white-space: nowrap;
  /* No line break */
  overflow: hidden;
  /* Hide overflow */
  text-overflow: ellipsis;
  /* Show ellipsis */
  width: 100px;
  /* Set element width */
}

.left-message {
  text-align: left;
  margin-left: 10px;
  margin-right: 10px;
  margin-top: 10px;
}

.right-message {
  text-align: right;
  margin-right: 10px;
  margin-left: 10px;
}

.message-backgroudcolor {
  background-color: #e7f7ff;
  border-radius: 5px;
}

.left-message-content {
  margin-left: 10px;
}

.right-message-content {
  margin-right: 10px;
}
</style>