<template>
  <div class="expire_container">
    <div class="header">
      <p>Return Book</p>
    </div>
    <div class="banner">
      <div class="expireDays">
        <p>{{ this.expireInfo.expireDays }} days remaining</p>
      </div>
      <div class="bookNumber">
        <el-input v-model="expireInfo.bookNumber" :readonly="true">
          <template slot="prepend">Book ID</template>
          <el-button slot="prepend" icon="el-icon-collection"> </el-button>
        </el-input>
      </div>
      <div class="closeDate">
        <el-input v-model="expireInfo.closeDate" :readonly="true">
          <template slot="prepend">Due Date</template>
          <el-button slot="prepend" icon="el-icon-date"></el-button></el-input>
      </div>

      <div class="violationMsg">
        <el-input v-model="returnInfo.violationMessage" placeholder="Leave empty if no violation">
          <template slot="prepend">Violation Info</template>
          <el-button slot="prepend" icon="iconfont icon-weizhangchaxun"></el-button></el-input>
      </div>
      <div class="adminId">
        <el-input v-model="expireInfo.bookAdminId" :readonly="true">
          <template slot="prepend">Admin ID</template>
          <el-button slot="prepend" icon="el-icon-s-custom"></el-button></el-input>
      </div>
      <div class="returnDate">
        <el-date-picker v-model="returnInfo.returnDate" type="datetime" placeholder="Select return date and time"
          default-time="12:00:00" value-format="yyyy-MM-dd HH:mm:ss" prefix-icon="el-icon-date">
        </el-date-picker>
      </div>
      <div class="return_button">
        <el-button type="warning" @click="returnBook">Return</el-button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      returnInfo: {
        returnDate: "",
        violationMessage: "",
        bookNumber: 0,
        violationAdminId: 0
      },
      expireInfo: {
        expireDays: 47,
        bookNumber: 192,
        closeDate: "",
        bookAdminId: 0
      }
    };
  },
  methods: {
    async getExpireInfo() {
      // Get book ID from route parameters
      const bookNumber = this.$route.query.bookNumber;
      // Send axios request
      const { data: res } = await this.$http.get('bookadmin/query_expire/' + bookNumber);
      if (res.status !== 200) {
        return this.$message.error(res.msg)
      }
      this.$message.success(
        {
          message: res.msg,
          duration: 1000
        }
      )
      this.expireInfo = res.data;
      const id = window.sessionStorage.getItem('bookAdminId')
      this.expireInfo.bookAdminId = parseInt(id);
      this.returnInfo.bookNumber = this.expireInfo.bookNumber;
    },
    async returnBook() {
      // Validate form parameters
      if (this.returnInfo.returnDate === "") {
        this.$message.error({
          message: "Return date cannot be empty",
          duration: 1000
        })
        return;
      }
      this.returnInfo.violationAdminId = parseInt(window.sessionStorage.getItem('bookAdminId'))
      const { data: res } = await this.$http.post('bookadmin/return_book', this.returnInfo)
      if (res.status !== 200) {
        return this.$message.error(res.msg)
      }
      this.$message.success(
        {
          message: res.msg,
          duration: 1000
        }
      )
      this.$router.push('/returnbook');
    }
  },
  created() {
    this.getExpireInfo();
  }
};
</script>

<style lang="less" scoped>
.header {
  text-align: center;
  height: 100px;

  p {
    font-size: 30px;
    line-height: 100px;
  }
}

.banner {
  height: 680px;
  display: flex;
  flex-direction: column;
  align-items: center;

  .expireDays {
    margin-top: 20px;
    width: 700px;
    height: 100px;
    border: 2px solid #ccc;
    text-align: center;

    p {
      line-height: 100px;
      font-size: 24px;
    }
  }

  div:nth-child(n + 2) {
    margin-top: 25px;
  }
}
</style>