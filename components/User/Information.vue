<template>
  <div class="information_container">
    <div class="backgroundImg">
      <img src="https://xxx.xiaobaitiao.icu/img/icu/202312211243635.jpg" alt="Background Image" />
    </div>
    <div class="information_header">
      <p>Personal Information</p>
      <p>
        <i class="el-icon-s-flag"></i> By reading we enrich the mind, by
        conversation we polish it.
      </p>
    </div>
    <div class="information_banner" v-loading="loading" element-loading-text="Loading..."
      element-loading-spinner="el-icon-loading" element-loading-background="rgba(0, 0, 0, 0.8)">
      <div class="information_banner_left">
        <div class="banner_left_main" v-if="show">
          <div class="number">
            <i class="el-icon-collection-tag"></i> Library Card ID:
            {{ this.user.cardNumber }}
          </div>
          <div class="name">
            <i class="iconfont icon-gerenxinxi"></i> Card Holder Name:
            {{ this.user.cardName }}
          </div>
          <div class="rule">
            <i class="iconfont icon-guizeshezhi"></i> Rule Number:
            {{ this.user.ruleNumber }}
          </div>
          <div class="status">
            <i class="el-icon-refresh"></i> Status:
            {{ this.user.status === 1 ? "Active" : "Disabled" }}
          </div>
        </div>
      </div>
      <div class="information_banner_right">
        <el-button type="primary" class="changePWD" @click="showEditDialog" v-if="show">Change Password</el-button>
      </div>
      <el-dialog title="Change Password" :visible.sync="editDialogVisible" width="50%" @close="editDialogClosed">
        <el-form :model="editForm" ref="editFormRef" :rules="editFormRules" label-width="120px">
          <el-form-item label="New Password" prop="password">
            <el-input v-model="editForm.password" type="password" placeholder="Enter new password"></el-input>
          </el-form-item>
          <el-form-item label="Confirm Password" prop="confirmPassword">
            <el-input v-model="editForm.confirmPassword" type="password" placeholder="Confirm new password"></el-input>
          </el-form-item>
        </el-form>
        <span slot="footer" class="dialog-footer">
          <el-button @click="editDialogVisible = false">Cancel</el-button>
          <el-button type="primary" @click="changePassword">Confirm</el-button>
        </span>
      </el-dialog>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    var validatePass2 = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('Please confirm your password'));
      } else if (value !== this.editForm.password) {
        callback(new Error('Passwords do not match!'));
      } else {
        callback();
      }
    };
    return {
      user: {
        ruleNumber: Number,
        cardNumber: Number,
        status: Number,
        userId: Number,
        cardName: "",
        username: "",
        password: "",
        createTime: "",
        updateTime: "",
      },
      editForm: {
        password: "",
        confirmPassword: "",
      },
      editFormRules: {
        password: [
          { required: true, message: "Please enter new password", trigger: "blur" },
          { min: 6, max: 15, message: "Password length should be 6-15 characters", trigger: "blur" }
        ],
        confirmPassword: [
          { validator: validatePass2, trigger: "blur" }
        ]
      },
      editDialogVisible: false,
      show: false,
      loading: true
    };
  },
  methods: {
    showEditDialog() {
      this.editDialogVisible = true;
    },
    editDialogClosed() {
      this.$refs.editFormRef.resetFields();
    },
    async getUserInformaton() {
      const userId = window.sessionStorage.getItem("userId");
      this.loading = true;
      const { data: res } = await this.$http.get(
        "user/get_information/" + userId
      );
      if (res.status !== 200) {
        return this.$message.error(res.msg);
      }
      this.$message.success({
        message: res.msg,
        duration: 1000,
      });
      this.user = res.data;
      this.show = true;
      this.loading = false;
    },
    async changePassword() {
      const { data: res } = await this.$http.post('user/update_password', {
        password: this.editForm.password,
        userId: window.sessionStorage.getItem('userId')
      })
      if (res.status !== 200) {
        return this.$message.error(res.msg);
      }
      this.$message.success(res.msg)
      this.editDialogVisible = false;
      this.$refs.editFormRef.resetFields();
      window.sessionStorage.clear();
      this.$router.push("/login");
    }
  },
  created() {
    this.getUserInformaton();
  },
};
</script>

<style lang="less" scoped>
.information_container {
  position: relative;
  height: 100%;
}

.backgroundImg {
  position: absolute;
  width: 100%;
  height: 100%;

  img {
    width: 100%;
    height: 100%;
    opacity: 0.3;
  }
}

.information_header {
  height: 200px;
  text-align: center;

  p:nth-child(1) {
    line-height: 140px;
    color: black;
    font-size: 36px;
  }

  p:nth-child(2) {
    color: black;
    font-size: 24px;
  }
}

.information_banner {
  display: flex;
  flex-direction: row;
  height: 400px;

  .information_banner_left {
    flex: 0.5;
    text-align: center;
  }

  .information_banner_right {
    flex: 0.5;
    text-align: left;
    line-height: 400px;
  }
}

.banner_left_main {
  margin-top: 120px;
  color: black;
  font-size: 20px;

  div {
    margin-top: 15px;
  }
}

.changePWD {
  position: absolute;
  top: 50%;
  left: 50%;
}
</style>