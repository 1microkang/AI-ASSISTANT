<template>
  <el-container class="home-container">
    <!-- Header Area -->
    <el-header>
      <div>
        <!-- <img src="../assets/heima.png" alt="" /> -->
        <span>Welcome to Library Management System</span>
        <span style="color: #ccc; font-size: 16px">Borrower Interface</span>
      </div>
      <div>
        <a href="https://github.com/luoye6/Vue_BookManageSystem" title="GitHub Repository" target="_blank"
          style="margin-right:10px">
          <svg t="1686048645435" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg"
            p-id="1265" width="30" height="30">
            <path
              d="M0 524.992q0 166.016 95.488 298.496t247.488 185.504q6.016 0.992 10.016 0.992t6.496-1.504 4-3.008 2.016-4.992 0.512-4.992v-100.512q-36.992 4-66.016-0.512t-45.504-14.016-28.992-23.488-16.992-25.504-8.992-24-5.504-14.496q-8.992-15.008-27.008-27.488t-27.008-20-2.016-14.496q50.016-26.016 112.992 66.016 34.016 51.008 119.008 30.016 10.016-40.992 40-70.016Q293.984 736 237.984 670.976t-56-158.016q0-87.008 55.008-151.008-22.016-64.992 6.016-136.992 28.992-2.016 64.992 11.488t50.496 23.008 25.504 17.504q56.992-16 128.512-16t129.504 16q12.992-8.992 28.992-19.008t48.992-21.504 60.992-9.504q27.008 71.008 7.008 135.008 56 64 56 151.008 0 92.992-56.992 158.496t-172 85.504q43.008 43.008 43.008 104v128.992q0 0.992 0.992 3.008 0 6.016 0.512 8.992t4.512 6.016 12 3.008q152.992-52 250.496-185.504t97.504-300.512q0-104-40.512-199.008t-108.992-163.488-163.488-108.992T512.032 12.96 313.024 53.472 149.536 162.464t-108.992 163.488-40.512 199.008z"
              p-id="1266" fill="#1296db"></path>
          </svg>
        </a>
        <a href="https://gitee.com/falle22222n-leaves/vue_-book-manage-system"
          title="Gitee Repository, Star to get database files" target="_blank">
          <svg t="1686041211368" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg"
            p-id="1834" width="30" height="30">
            <path
              d="M512 1024C229.222 1024 0 794.778 0 512S229.222 0 512 0s512 229.222 512 512-229.222 512-512 512z m259.149-568.883h-290.74a25.293 25.293 0 0 0-25.292 25.293l-0.026 63.206c0 13.952 11.315 25.293 25.267 25.293h177.024c13.978 0 25.293 11.315 25.293 25.267v12.646a75.853 75.853 0 0 1-75.853 75.853h-240.23a25.293 25.293 0 0 1-25.267-25.293V417.203a75.853 75.853 0 0 1 75.827-75.853h353.946a25.293 25.293 0 0 0 25.267-25.292l0.077-63.207a25.293 25.293 0 0 0-25.268-25.293H417.152a189.62 189.62 0 0 0-189.62 189.645V771.15c0 13.977 11.316 25.293 25.294 25.293h372.94a170.65 170.65 0 0 0 170.65-170.65V480.384a25.293 25.293 0 0 0-25.293-25.267z"
              fill="#C71D23" p-id="1835"></path>
          </svg>
        </a>
        <div>
          <el-avatar src="https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png" :size="35"
            style="margin-right: 10px"></el-avatar>
        </div>

        <div class="user">User:{{ this.user.cardName }}</div>
        <el-button type="info" @click="logout">Logout</el-button>
      </div>
    </el-header>
    <!-- Main Content Area -->
    <el-container>
      <!-- Sidebar -->
      <el-aside :width="isCollapse ? '64px' : '200px'">
        <div class="toggle-button" @click="toggleCollapse">|||</div>
        <!-- Sidebar Menu -->
        <el-menu :default-active="activePath" class="el-menu-vertical-demo" background-color="#fff" text-color="black"
          active-text-color="#ffd04b" :router="true" :collapse="isCollapse" :collapse-transition="false">
          <el-menu-item index="index" @click="saveNavState('index')">
            <i class="iconfont icon-shouyefill"></i>
            <span slot="title">Home</span>
          </el-menu-item>
          <el-menu-item index="search" @click="saveNavState('search')">
            <i class="iconfont icon-sousuoxiao"></i>
            <span slot="title">Book Search</span>
          </el-menu-item>
          <el-menu-item index="rule" @click="saveNavState('rule')">
            <i class="iconfont icon-guizeshezhi"></i>
            <span slot="title">Borrower Rules</span>
          </el-menu-item>
          <el-menu-item index="notice" @click="saveNavState('notice')">
            <i class="iconfont icon-gonggao1"></i>
            <span slot="title">Announcements</span>
          </el-menu-item>
          <el-menu-item index="information" @click="saveNavState('information')">
            <i class="iconfont icon-gerenxinxi"></i>
            <span slot="title">Profile</span>
          </el-menu-item>
          <el-menu-item index="borrow" @click="saveNavState('borrow')">
            <i class="iconfont icon-tushuqikan"></i>
            <span slot="title">Borrow Records</span>
          </el-menu-item>
          <el-menu-item index="violation" @click="saveNavState('violation')">
            <i class="iconfont icon-weizhangchaxun"></i>
            <span slot="title">Violation Records</span>
          </el-menu-item>
          <el-menu-item index="comment" @click="saveNavState('comment')">
            <i class="iconfont icon-liuyan"></i>
            <span slot="title">Feedback</span>
          </el-menu-item>
          <el-menu-item index="intelligent" @click="saveNavState('intelligent')">
            <i class="el-icon-monitor"></i>
            <span slot="title">Recommendations</span>
          </el-menu-item>
        </el-menu>
      </el-aside>
      <!-- Main Content -->
      <el-main>
        <router-view></router-view>
      </el-main>
    </el-container>
  </el-container>
</template>

<script>
export default {
  data() {
    return {
      menulist: [],
      iconsObj: {
        125: "iconfont icon-user",
        103: "iconfont icon-tijikongjian",
        101: "iconfont icon-shangpin",
        102: "iconfont icon-danju",
        145: "iconfont icon-baobiao",
      },
      isCollapse: false,
      activePath: "",
      user: {
        userId: Number,
        cardNumber: Number,
        ruleNumber: Number,
        status: Number,
        cardName: "",
        username: "",
        password: "",
        createTime: "",
        updateTime: "",
      },
    };
  },
  async created() {
    this.activePath = window.sessionStorage.getItem("activePath");
    const stringId = window.sessionStorage.getItem("userId");
    const id = parseInt(stringId);
    this.user.userId = id;
    const { data: res } = await this.$http.post("user/getData", this.user);
    window.sessionStorage.setItem('cardNumber', res.data.cardNumber)
    this.user = res.data;
  },
  methods: {
    logout() {
      window.sessionStorage.clear();
      this.$router.push("/login");
    },
    toggleCollapse() {
      this.isCollapse = !this.isCollapse;
    },
    saveNavState(activePath) {
      window.sessionStorage.setItem("activePath", activePath);
      this.activePath = activePath;
    },
  },
};
</script>

<style lang="less" scoped>
.home-container {
  height: 100%;
}

.el-header {
  background-color: rgb(34, 34, 34);
  display: flex;
  justify-content: space-between;
  padding-left: 0px;
  align-items: center;
  color: #fff;
  font-size: 20px;
  border-radius: 10px;

  >div {
    display: flex;
    align-items: center;

    span {
      margin-left: 15px;
    }
  }
}

.el-aside {
  background-color: #fff;

  .el-menu {
    border-right: none;
  }
}

.el-main {
  background-color: #eaedf1;
  padding: 20px;
}

.iconfont {
  margin-right: 10px;
}

.toggle-button {
  background-color: #4a5064;
  font-size: 10px;
  line-height: 24px;
  color: #fff;
  text-align: center;
  letter-spacing: 0.2em;
  cursor: pointer;
}

.user {
  margin-right: 15px;
  color: #ccc;
  font-size: 16px;
}

.el-menu-item:hover {
  background-color: rgb(51, 122, 183) !important;
}
</style>