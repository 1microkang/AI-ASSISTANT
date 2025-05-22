<template>
  <div class="login_container">
    <div class="login_title">System Administrator Login</div>
    <div class="login_box">
      <!-- Avatar area -->
      <div class="avatar_box">
        <img src="../../assets/images/dinosaur.jpg" alt="" />
      </div>
      <!-- Login form area -->
      <el-form ref="loginFormRef" :model="loginForm" :rules="loginFormRules" label-width="0px" class="login_form">
        <!-- Username -->
        <el-form-item prop="username">
          <el-input v-model.trim="loginForm.username" prefix-icon="iconfont icon-gerenxinxi"></el-input>
        </el-form-item>
        <!-- Password -->
        <el-form-item prop="password">
          <el-input v-model="loginForm.password" prefix-icon="iconfont icon-tianchongxing-" type="password"
            @keyup.enter.native="login" :show-password="true"></el-input>
        </el-form-item>
        <!-- Buttons area -->
        <el-form-item class="btns">
          <el-button type="primary" @click="login" :loading="loginLoading">Login</el-button>
          <el-button type="info" @click="resetLoginForm">Reset</el-button>
        </el-form-item>
      </el-form>
    </div>
    <vue-particles class="login-bg" color="#39AFFD" :particleOpacity="0.7" :particlesNumber="100" shapeType="circle"
      :particleSize="4" linesColor="#8DD1FE" :linesWidth="1" :lineLinked="true" :lineOpacity="0.4" :linesDistance="150"
      :moveSpeed="3" :hoverEffect="true" hoverMode="grab" :clickEffect="true" clickMode="push">
    </vue-particles>
    <div class="footer">
      <span style="font-weight: bold;color:white;margin-bottom: 10px">
        Switch Login Page
      </span>
      <span><i class="iconfont icon-haoyou" @click="goUser"></i></span>
    </div>
    <!-- <div class="footer2">
      <el-popover placement="top-start" :width="150" trigger="hover">
        <p slot="reference"> Contact Author| ©2022-2023 By Xiaobaitiao<br /> </p>
        <img src="https://pic.yupi.icu/5563/202312061315664.png" style="height: 100px; width: 100px" />
      </el-popover>
      <a href="https://beian.miit.gov.cn">ICP:浙ICP备2023044565号-2 |</a>
      <a href="https://beian.mps.gov.cn/#/query/webSearch">
        <img src="https://xxx.xiaobaitiao.icu/img/icu/202312211243636.png"
          style="height: 16px; width: 16px; margin: 5px 0px 0px 5px" />
        浙公网安备33028202001002号
      </a>
    </div> -->
  </div>
</template>

<script>
export default {
  data() {
    return {
      // Login form
      loginForm: {
        username: "",
        password: "",
      },
      // Login form validation rules
      loginFormRules: {
        username: [
          { required: true, message: "Username cannot be empty", trigger: "blur" },
          {
            min: 3,
            max: 20,
            message: "Length should be between 3 to 20 characters",
            trigger: "blur",
          },
        ],
        password: [
          { required: true, message: "Password cannot be empty", trigger: "blur" },
          {
            min: 6,
            max: 15,
            message: "Length should be between 6 to 15 characters",
            trigger: "blur",
          },
        ],
      },
      loginLoading: false
    };
  },
  methods: {
    resetLoginForm() {
      this.$refs.loginFormRef.resetFields();
    },
    login() {
      this.$refs.loginFormRef.validate(async (valid) => {
        // console.log(valid);
        // If form validation fails, return directly
        if (!valid) {
          return;
        }
        this.loginLoading = true;
        const username = this.loginForm.username;
        const password = this.loginForm.password;
        // Send axios request to database, redirect if login succeeds
        const { data: res } = await this.$http.post(
          "admin/login",
          {
            username,
            password
          }
        );
        if (res.status !== 200) {
          this.loginLoading = false;
          return this.$message.error(res.msg);
        }
        this.$message.success("Login successful");
        this.loginLoading = false;
        // console.log(res);
        window.sessionStorage.setItem("token", res.map.token);
        window.sessionStorage.setItem("adminId", res.map.id);
        this.$router.push("/homeadmin");
      });
    },
    goUser() {
      this.$router.push("/login");
    },
  },
};
</script>

<style lang="less" scoped>
.footer2 {
  position: absolute;
  bottom: 0px;
  left: 35%;
  color: #ccc;

  a {
    color: #ccc;
  }
}

.login_container {
  // background-color: #2b4b6b;
  background: url(../../assets/images/animeboySkyMin.jpg) no-repeat 0px 0px;
  background-size: cover;
  height: 100%;
}

.login_box {
  height: 300px;
  width: 450px;
  background-color: #fff;
  border-radius: 3px;
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);

  .avatar_box {
    width: 130px;
    height: 130px;
    border: 1px solid #eee;
    border-radius: 50%;
    padding: 10px;
    box-shadow: 0 0 10px #ddd;
    position: absolute;
    left: 50%;
    transform: translate(-50%, -50%);
    background-color: #fff;

    img {
      width: 100%;
      height: 100%;
      border-radius: 50%;
      background-color: #eee;
    }
  }
}

.login_form {
  position: absolute;
  bottom: 0;
  width: 100%;
  padding: 0 20px;
  box-sizing: border-box;
}

.btns {
  display: flex;
  justify-content: flex-end;
}

.login_title {
  position: relative;
  top: 5%;
  font-size: 36px;
  color: white;
  text-align: center;
  font-weight: 700;
  //控制字体间距
  letter-spacing: 10px;
}

.footer {
  display: flex;
  position: absolute;
  flex-direction: column;
  bottom: 0;
  right: 0;
  width: 100px;
  height: 120px;

  // background-color: pink;
  span {
    // width: 100%;
    // background-color: red;
    text-align: center;
  }
}
</style>