<template>
  <div class="rule_container">
    <div class="header">
      <p>Reader Rules Information</p>
    </div>
    <div class="banner">
      <el-tooltip v-for="item in ruleList" v-loading="loading" element-loading-text="Loading..."
        element-loading-spinner="el-icon-loading" element-loading-background="rgba(0, 0, 0, 0.8)" :key="item.ruleId"
        effect="dark" placement="right">
        <div slot="content" class="content_tip">Borrow Limit: {{ item.bookLimitNumber }}<br />Borrow Days: {{
          item.bookDays }}
          <br />Allowed Libraries: {{ item.bookLimitLibrary }}<br />Overdue Fee/Day: {{ item.bookOverdueFee }}
        </div>
        <el-button style="font-size:16px">Rule ID: {{ item.bookRuleId }}</el-button>
      </el-tooltip>

    </div>
  </div>
</template>

<script>
import { Loading } from 'element-ui';
export default {
  data() {
    return {
      ruleList: [
        {
          ruleId: 0,
          bookRuleId: Number,
          bookDays: Number,
          bookLimitNumber: Number,
          bookOverdueFee: Number,
          bookLimitLibrary: "",
          createTime: "",
          updateTime: "",

        }

      ],
      loading: true
    }
  },
  methods: {
    async getRuleList() {
      const { data: res } = await this.$http.get("user/get_rulelist")
      if (res.status !== 200) {
        this.loading = false;
        return this.$message.error(res.msg);
      }
      this.$message.success({
        message: res.msg,
        duration: 1000
      })
      this.loading = false;
      this.ruleList = res.data
    }
  },
  created() {
    this.getRuleList()
  }
};
</script>

<style lang="less" scoped>
.rule_container {
  position: relative;
}

.header {
  position: absolute;
  left: 50%;
  transform: translate(-50%);

  p {
    font-size: 36px;
    color: rgb(70, 130, 180);
  }
}

.banner {
  display: flex;
  flex-direction: column;
  position: absolute;
  left: 50%;
  transform: translate(-50%);

}

.el-tooltip {
  width: 500px;
  font-size: 16px;
  color: white;
}

.el-tooltip:hover {
  color: black;
}

.el-tooltip:nth-child(1) {
  margin-top: 100px;
}

.el-tooltip:nth-child(n+2) {
  margin-top: 50px;
  margin-left: 0px;
}

.el-tooltip:nth-child(odd) {
  background-color: pink;
}

.el-tooltip:nth-child(even) {
  background-color: rgb(49, 176, 213)
}

.content_tip {
  font-size: 16px;
}
</style>