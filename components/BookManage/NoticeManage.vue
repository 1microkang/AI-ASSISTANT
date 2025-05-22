<template>
  <div class="search_container">
    <!-- Breadcrumb Navigation -->
    <el-breadcrumb separator-class="el-icon-arrow-right">
      <el-breadcrumb-item>Home</el-breadcrumb-item>
      <el-breadcrumb-item>Announcement Management</el-breadcrumb-item>
    </el-breadcrumb>
    <el-card shadow="always">
      <!-- Search and Action Area -->
      <el-row>
        <el-col :span="4">
          <el-button type="primary" @click="showAddDialog()">
            <i class="el-icon-s-promotion"></i> Post New Announcement</el-button>
        </el-col>
      </el-row>
      <!-- Table Area -->
      <el-table :data="tableData" border style="width: 100%" stripe v-loading="loading"
        element-loading-text="Loading..." element-loading-spinner="el-icon-loading"
        element-loading-background="rgba(0, 0, 0, 0.8)">
        <el-table-column prop="noticeId" label="ID"> </el-table-column>
        <el-table-column prop="noticeTitle" label="Title"> </el-table-column>
        <el-table-column prop="noticeContent" label="Content"> </el-table-column>
        <el-table-column prop="createTime" label="Publish Date"> </el-table-column>
        <el-table-column label="Actions">
          <template slot-scope="scope">
            <!-- Edit Button -->
            <el-tooltip effect="dark" content="Edit" placement="top" :enterable="false">
              <el-button type="primary" icon="el-icon-edit" size="mini"
                @click="showEditDialog(scope.row.noticeId)"></el-button></el-tooltip>

            <!-- Delete Button -->
            <el-tooltip effect="dark" content="Delete" placement="top" :enterable="false">
              <el-button type="danger" icon="el-icon-delete" size="mini"
                @click="removeNoticeById(scope.row.noticeId)"></el-button>
            </el-tooltip>
          </template>
        </el-table-column>
      </el-table>
      <!-- Pagination Area -->
      <el-pagination @size-change="handleSizeChange" @current-change="handleCurrentChange"
        :current-page="queryInfo.pageNum" :page-sizes="[1, 2, 3, 4, 5]" :page-size="queryInfo.pageSize"
        layout="total, sizes, prev, pager, next, jumper" :total="this.total">
      </el-pagination>
      <!-- Edit Announcement Dialog -->
      <el-dialog title="Edit Announcement" :visible.sync="editDialogVisible" width="50%" @close="editDialogClosed">
        <el-form :model="editForm" ref="editFormRef" :rules="editFormRules" label-width="100px">
          <el-form-item label="Title" prop="noticeTitle">
            <el-input v-model="editForm.noticeTitle"></el-input>
          </el-form-item>
          <el-form-item label="Content" prop="noticeContent">
            <el-input type="textarea" v-model="editForm.noticeContent"></el-input>
          </el-form-item>
        </el-form>
        <span slot="footer" class="dialog-footer">
          <el-button @click="editDialogVisible = false">Cancel</el-button>
          <el-button type="primary" @click="editNoticeById">Confirm</el-button>
        </span>
      </el-dialog>
      <!-- Add Announcement Dialog -->
      <el-dialog title="Add Announcement" :visible.sync="addDialogVisible" width="50%" @close="addDialogClosed">
        <el-form :model="addForm" ref="addFormRef" :rules="addFormRules" label-width="100px">
          <el-form-item label="Title" prop="noticeTitle">
            <el-input v-model="addForm.noticeTitle"></el-input>
          </el-form-item>
          <el-form-item label="Content" prop="noticeContent">
            <el-input type="textarea" v-model="addForm.noticeContent"></el-input>
          </el-form-item>
        </el-form>
        <span slot="footer" class="dialog-footer">
          <el-button @click="addDialogVisible = false">Cancel</el-button>
          <el-button type="primary" @click="addNotice">Add Announcement</el-button>
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
        noticeTitle: "",
        noticeContent: "",
      },
      editFormRules: {
        noticeTitle: [
          { required: true, message: "Please enter announcement title", trigger: "blur" },
          {
            min: 6,
            max: 30,
            message: "Length should be 6 to 30 characters",
            trigger: "blur",
          },
        ],
        noticeContent: [
          { required: true, message: "Please enter announcement content", trigger: "blur" },
        ],
      },
      addDialogVisible: false,
      addForm: {
        noticeTitle: "",
        noticeContent: "",
        noticeAdminId: 0
      },
      addFormRules: {
        noticeTitle: [
          { required: true, message: "Please enter announcement title", trigger: "blur" },
          {
            min: 6,
            max: 30,
            message: "Length should be 6 to 30 characters",
            trigger: "blur",
          },
        ],
        noticeContent: [
          { required: true, message: "Please enter announcement content", trigger: "blur" },
        ],
      },
      queryInfo: {
        pageNum: 1,
        pageSize: 5,
      },
      total: 0,
      loading: true
    };
  },
  methods: {
    handleSizeChange(val) {
      this.queryInfo.pageSize = val;
      this.getNoticeList();
    },
    handleCurrentChange(val) {
      this.queryInfo.pageNum = val;
      this.getNoticeList();
    },
    // Show edit dialog and populate data from database
    async showEditDialog(id) {
      this.loading = true;
      const { data: res } = await this.$http.get('bookadmin/get_notice/' + id);
      if (res.status !== 200) {
        return this.$message.error(res.msg)
      }
      this.editForm = res.data;
      this.editDialogVisible = true;
      this.loading = false;
    },
    // Reset form when edit dialog is closed
    editDialogClosed() {
      this.$refs.editFormRef.resetFields();
    },
    // Edit announcement by ID
    async editNoticeById() {
      const { data: res } = await this.$http.put('bookadmin/update_notice/' + this.editForm.noticeId, {
        noticeTitle: this.editForm.noticeTitle,
        noticeContent: this.editForm.noticeContent
      })
      if (res.status !== 200) {
        return this.$message.error(res.msg)
      }
      this.editDialogVisible = false;
      this.getNoticeList();
      this.$message.success(res.msg)
    },
    // Delete announcement
    async removeNoticeById(id) {
      // Confirm deletion with user
      const confirmResult = await this.$confirm(
        "This will permanently delete the announcement. Continue?",
        "Warning",
        {
          confirmButtonText: "Confirm",
          cancelButtonText: "Cancel",
          type: "warning",
        }
      ).catch((error) => {
        return error;
      });

      if (confirmResult !== "confirm") {
        return this.$message.info("Deletion cancelled");
      }

      const { data: res } = await this.$http.get('bookadmin/delete_notice/' + id)
      if (res.status !== 200) {
        return this.$message.error(res.msg);
      }
      this.$message.success({
        message: res.msg,
        duration: 1500,
      });
      this.getNoticeList();
    },
    // Reset form when add dialog is closed
    addDialogClosed() {
      this.$refs.addFormRef.resetFields();
    },
    // Show add dialog
    showAddDialog() {
      this.addDialogVisible = true;
    },
    async getNoticeList() {
      this.loading = true;
      const { data: res } = await this.$http.post('bookadmin/get_noticelist', this.queryInfo)

      this.tableData = [];
      if (res.status !== 200) {
        this.total = 0;
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
    async addNotice() {
      this.addDialogVisible = false;
      this.addForm.noticeAdminId = parseInt(window.sessionStorage.getItem('bookAdminId'))
      const { data: res } = await this.$http.post('bookadmin/add_notice', this.addForm)
      if (res.status !== 200) {
        return this.$message.error(res.msg)
      }
      this.$message.success({
        message: res.msg,
        duration: 1000
      })
      this.getNoticeList();
    }
  },
  created() {
    this.getNoticeList();
  }
};
</script>

<style></style>