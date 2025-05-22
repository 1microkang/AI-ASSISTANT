<template>
  <div class="search_container">
    <!-- 面包屑导航区域 -->
    <el-breadcrumb separator-class="el-icon-arrow-right">
      <el-breadcrumb-item>Home</el-breadcrumb-item>
      <el-breadcrumb-item>Library Admin Management</el-breadcrumb-item>
    </el-breadcrumb>
    <el-card shadow="always">
      <!-- 搜索内容和导出区域 -->
      <el-row>
        <el-col :span="4">
          <el-button type="primary" @click="showAddDialog()">
            <i class="el-icon-plus"></i> Add Admin</el-button>
        </el-col>
        <el-col :span="2" style="float: right">
          <download-excel class="export-excel-wrapper" :data="tableData" :fields="json_fields" :header="title"
            name="Library Admin.xls">
            <!-- 上面可以自定义自己的样式，还可以引用其他组件button -->
            <el-button type="primary" class="el-icon-printer" size="mini">Export Excel</el-button>
          </download-excel>
        </el-col>
        <el-col :span="2" style="float: right">
          <el-button type="primary" class="el-icon-printer" size="mini" @click="downLoad">Export PDF</el-button>
        </el-col>
        <el-col :span="2" style="float: right">
          <el-button type="success" class="el-icon-full-screen" size="mini" @click="fullScreen">Full Screen</el-button>
        </el-col>
      </el-row>
      <!-- 表格区域 -->
      <el-table :data="tableData" border style="width: 100%" stripe id="pdfDom"
        :default-sort="{ prop: 'bookAdminId', order: 'ascending' }" v-loading="loading" element-loading-text="拼命加载中"
        element-loading-spinner="el-icon-loading" element-loading-background="rgba(0, 0, 0, 0.8)">
        <el-table-column prop="bookAdminId" label="ID" sortable>
        </el-table-column>
        <el-table-column prop="username" label="Username"> </el-table-column>
        <el-table-column prop="bookAdminName" label="Name"> </el-table-column>
        <el-table-column prop="email" label="Email"> </el-table-column>
        <el-table-column label="Operations">
          <template slot-scope="scope">
            <!-- 修改按钮 -->
            <el-tooltip effect="dark" content="Edit" placement="top" :enterable="false">
              <el-button type="primary" icon="el-icon-edit" size="mini"
                @click="showEditDialog(scope.row.bookAdminId)"></el-button></el-tooltip>

            <!-- 删除按钮 -->
            <el-tooltip effect="dark" content="Delete" placement="top" :enterable="false">
              <el-button type="danger" icon="el-icon-delete" size="mini"
                @click="removeUserById(scope.row.bookAdminId)"></el-button>
            </el-tooltip>
          </template>
        </el-table-column>
      </el-table>
      <!-- 分页查询区域 -->
      <el-pagination @size-change="handleSizeChange" @current-change="handleCurrentChange"
        :current-page="queryInfo.pageNum" :page-sizes="[1, 2, 3, 4, 5]" :page-size="queryInfo.pageSize"
        layout="total, sizes, prev, pager, next, jumper" :total="this.total">
      </el-pagination>
      <!-- 修改公告的对话框 -->
      <el-dialog title="Edit Admin" :visible.sync="editDialogVisible" width="50%" @close="editDialogClosed">
        <el-form :model="editForm" ref="editFormRef" :rules="editFormRules" label-width="100px">
          <el-form-item label="Name" prop="bookAdminName">
            <el-input v-model="editForm.bookAdminName"></el-input>
          </el-form-item>
          <el-form-item label="Username" prop="username">
            <el-input v-model="editForm.username"></el-input>
          </el-form-item>
          <el-form-item label="Password" prop="password">
            <el-input v-model="editForm.password" type="password" show-password></el-input>
          </el-form-item>
          <el-form-item label="Email" prop="email">
            <el-input v-model="editForm.email"></el-input>
          </el-form-item>
        </el-form>
        <span slot="footer" class="dialog-footer">
          <el-button @click="editDialogVisible = false">Cancel</el-button>
          <el-button type="primary" @click="updateBookAdmin">Confirm</el-button>
        </span>
      </el-dialog>
      <!-- 添加管理员的对话框 -->
      <el-dialog title="Add Admin" :visible.sync="addDialogVisible" width="50%" @close="addDialogClosed">
        <el-form :model="addForm" ref="addFormRef" :rules="addFormRules" label-width="100px">
          <el-form-item label="Name" prop="bookAdminName">
            <el-input v-model="addForm.bookAdminName"></el-input>
          </el-form-item>
          <el-form-item label="Username" prop="username">
            <el-input v-model="addForm.username"></el-input>
          </el-form-item>
          <el-form-item label="Password" prop="password">
            <el-input v-model="addForm.password"></el-input>
          </el-form-item>
          <el-form-item label="Email" prop="email">
            <el-input v-model="addForm.email"></el-input>
          </el-form-item>
        </el-form>
        <span slot="footer" class="dialog-footer">
          <el-button @click="addDialogVisible = false">Cancel</el-button>
          <el-button type="primary" @click="addBookAdmin">Add Admin</el-button>
        </span>
      </el-dialog>
    </el-card>
  </div>
</template>

<script>
export default {
  data() {
    return {
      tableData: [],
      editDialogVisible: false,
      editForm: {
        username: "",
        password: "",
        email: "",
        bookAdminName: "",
      },
      editFormRules: {
        username: [
          { required: true, message: "Please enter username", trigger: "blur" },
          {
            min: 5,
            max: 30,
            message: "Length should be 5 to 30 characters",
            trigger: "blur",
          },
        ],
        password: [
          { required: true, message: "Please enter password", trigger: "blur" },
          {
            min: 6,
            max: 50,
            message: "Length should be 6 to 50 characters",
            trigger: "blur",
          },
        ],
        email: [
          {
            required: true,
            message: "Please enter a valid email",
            trigger: "blur",
            type: "email",
          },
          {
            min: 6,
            max: 50,
            message: "Length should be 6 to 50 characters",
            trigger: "blur",
          },
        ],
        bookAdminName: [
          { required: true, message: "Please enter name", trigger: "blur" },
        ],
      },
      addDialogVisible: false,
      addForm: {
        username: "",
        password: "",
        email: "",
        bookAdminName: "",
      },
      addFormRules: {
        username: [
          { required: true, message: "Please enter username", trigger: "blur" },
          {
            min: 5,
            max: 30,
            message: "Length should be 5 to 30 characters",
            trigger: "blur",
          },
        ],
        password: [
          { required: true, message: "Please enter password", trigger: "blur" },
          {
            min: 6,
            max: 50,
            message: "Length should be 6 to 50 characters",
            trigger: "blur",
          },
        ],
        email: [
          {
            required: true,
            message: "Please enter a valid email",
            trigger: "blur",
            type: "email",
          },
          {
            min: 6,
            max: 50,
            message: "Length should be 6 to 50 characters",
            trigger: "blur",
          },
        ],
        bookAdminName: [
          { required: true, message: "Please enter name", trigger: "blur" },
        ],
      },
      queryInfo: {
        pageNum: 1,
        pageSize: 5,
      },
      total: 0,
      title: "Library Admin",
      json_fields: {
        "Admin ID": "bookAdminId",
        "Username": "username",
        "Name": "bookAdminName",
        "Email": "email",
      },
      loading: true
    };
  },
  methods: {
    handleSizeChange(val) {
      this.queryInfo.pageSize = val;
      this.getBookAdminList();
    },
    handleCurrentChange(val) {
      this.queryInfo.pageNum = val;
      this.getBookAdminList();
    },
    // Make the edit dialog visible and populate data from database
    async showEditDialog(id) {
      const { data: res } = await this.$http.get("admin/get_bookadmin/" + id);
      console.log(res);
      if (res.status !== 200) {
        return this.$message.error(res.msg);
      }
      this.editForm = res.data;
      // Make the edit dialog visible
      this.editDialogVisible = true;
    },
    // Listen for edit dialog close event, reset form when closed
    editDialogClosed() {
      this.$refs.editFormRef.resetFields();
    },
    // Delete admin
    async removeUserById(id) {
      // Confirm dialog to ask user if they want to delete
      const confirmResult = await this.$confirm(
        "This will permanently delete this admin. Continue?",
        "Warning",
        {
          confirmButtonText: "Confirm",
          cancelButtonText: "Cancel",
          type: "warning",
        }
      ).catch((error) => {
        return error;
      });
      // If user confirms deletion, returns 'confirm'
      // If user cancels deletion, returns 'cancel'
      if (confirmResult !== "confirm") {
        return this.$message.info("Deletion cancelled");
      }
      // If confirmed, send axios request and check response status
      const { data: res } = await this.$http.delete(
        "admin/delete_bookadmin/" + id
      );
      if (res.status !== 200) {
        return this.$message.error(res.msg);
      }
      this.$message.success({
        message: res.msg,
        duration: 1000,
      });
      this.getBookAdminList();
    },
    // Listen for add dialog close event, reset form when closed
    addDialogClosed() {
      this.$refs.addFormRef.resetFields();
    },
    // When user clicks to add new admin, make add dialog visible
    showAddDialog() {
      this.addDialogVisible = true;
    },
    // Get library admin list
    async getBookAdminList() {
      this.loading = true;
      const { data: res } = await this.$http.post(
        "admin/get_bookadminlist",
        this.queryInfo
      );
      if (res.status !== 200) {
        this.loading = false;
        return this.$message.error(res.msg);
      }
      this.$message.success({
        message: res.msg,
        duration: 1000,
      });
      this.tableData = res.data.records;
      this.total = parseInt(res.data.total);
      this.loading = false;
    },
    async addBookAdmin() {
      const { data: res } = await this.$http.post(
        "admin/add_bookadmin",
        this.addForm
      );
      if (res.status !== 200) {
        return this.$message.error(res.msg);
      }
      this.$message.success({
        message: res.msg,
        duration: 1500,
      });
      this.getBookAdminList();
      this.addDialogVisible = false;
    },
    async updateBookAdmin() {
      const { data: res } = await this.$http.put(
        "admin/update_bookadmin",
        this.editForm
      );
      if (res.status !== 200) {
        return this.$message.error(res.msg);
      }
      this.$message.success({
        message: res.msg,
        duration: 1500,
      });
      this.getBookAdminList();
      this.editDialogVisible = false;
    },
    downLoad() {
      this.getPdf(this.title); // Parameter is the PDF filename to download
    },
    fullScreen() {
      // DOM property to check if currently in fullscreen mode
      let full = document.fullscreenElement;
      // Toggle fullscreen mode
      if (!full) {
        // Request fullscreen mode
        document.documentElement.requestFullscreen();
      } else {
        // Exit fullscreen mode
        document.exitFullscreen();
      }
    }
  },
  created() {
    this.getBookAdminList();
  },
};
</script>
<style></style>