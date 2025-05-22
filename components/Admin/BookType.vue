<template>
  <div class="search_container">
    <!-- Breadcrumb Navigation -->
    <el-breadcrumb separator-class="el-icon-arrow-right">
      <el-breadcrumb-item>Home</el-breadcrumb-item>
      <el-breadcrumb-item>Book Categories</el-breadcrumb-item>
    </el-breadcrumb>
    <el-card shadow="always">
      <!-- Search and Export Area -->
      <el-row>
        <el-col :span="4">
          <el-button type="primary" @click="showAddDialog()">
            <i class="el-icon-plus"></i>Add</el-button>
        </el-col>
        <el-col :span="2" style="float: right">
          <download-excel class="export-excel-wrapper" :data="tableData" :fields="json_fields" :header="title"
            name="Book Categories.xls">
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
      <!-- Table Area -->
      <el-table :data="tableData" border style="width: 100%" stripe id="pdfDom"
        :default-sort="{ prop: 'typeId', order: 'ascending' }" v-loading="loading" element-loading-text="拼命加载中"
        element-loading-spinner="el-icon-loading" element-loading-background="rgba(0, 0, 0, 0.8)">
        <el-table-column prop="typeId" label="ID" sortable> </el-table-column>
        <el-table-column prop="typeName" label="Category Name"> </el-table-column>
        <el-table-column prop="typeContent" label="Description"> </el-table-column>
        <el-table-column label="Operations">
          <template slot-scope="scope">
            <!-- Edit Button -->
            <el-tooltip effect="dark" content="Edit" placement="top" :enterable="false">
              <el-button type="primary" icon="el-icon-edit" size="mini"
                @click="showEditDialog(scope.row.typeId)"></el-button></el-tooltip>

            <!-- Delete Button -->
            <el-tooltip effect="dark" content="Delete" placement="top" :enterable="false">
              <el-button type="danger" icon="el-icon-delete" size="mini"
                @click="removeUserById(scope.row.typeId)"></el-button>
            </el-tooltip>
          </template>
        </el-table-column>
      </el-table>
      <!-- Pagination Area -->
      <el-pagination @size-change="handleSizeChange" @current-change="handleCurrentChange"
        :current-page="queryInfo.pageNum" :page-sizes="[1, 2, 3, 4, 5]" :page-size="queryInfo.pageSize"
        layout="total, sizes, prev, pager, next, jumper" :total="this.total">
      </el-pagination>
      <!-- Edit Category Dialog -->
      <el-dialog title="Edit Category" :visible.sync="editDialogVisible" width="50%" @close="editDialogClosed">
        <el-form :model="editForm" ref="editFormRef" :rules="editFormRules" label-width="120px">
          <el-form-item label="Category Name" prop="typeName">
            <el-input v-model="editForm.typeName"></el-input>
          </el-form-item>
          <el-form-item label="Description" prop="typeContent">
            <el-input v-model="editForm.typeContent" type="textarea"></el-input>
          </el-form-item>
        </el-form>
        <span slot="footer" class="dialog-footer">
          <el-button @click="editDialogVisible = false">Cancel</el-button>
          <el-button type="primary" @click="updateBookType">Confirm</el-button>
        </span>
      </el-dialog>
      <!-- Add Category Dialog -->
      <el-dialog title="Add Category" :visible.sync="addDialogVisible" width="50%" @close="addDialogClosed">
        <el-form :model="addForm" ref="addFormRef" :rules="addFormRules" label-width="120px">
          <el-form-item label="Category Name" prop="typeName">
            <el-input v-model="addForm.typeName"></el-input>
          </el-form-item>
          <el-form-item label="Description" prop="typeContent">
            <el-input v-model="addForm.typeContent" type="textarea"></el-input>
          </el-form-item>
        </el-form>
        <span slot="footer" class="dialog-footer">
          <el-button @click="addDialogVisible = false">Cancel</el-button>
          <el-button type="primary" @click="addBookType">Add Category</el-button>
        </span>
      </el-dialog>
    </el-card>
  </div>
</template>

<script>
export default {
  data() {
    return {
      tableData: [
        {
          typeId: 183,
          typeName: "Fairy Tale",
          typeContent: "Children's world",
        },
      ],

      editDialogVisible: false,
      editForm: {
        typeName: "",
        typeContent: "",
      },
      editFormRules: {
        typeName: [
          { required: true, message: "Please enter category name", trigger: "blur" },
        ],
        typeContent: [
          { required: true, message: "Please enter category description", trigger: "blur" },
        ],
      },
      addDialogVisible: false,
      addForm: {
        typeName: "",
        typeContent: "",
      },
      addFormRules: {
        typeName: [
          { required: true, message: "Please enter category name", trigger: "blur" },
        ],
        typeContent: [
          { required: true, message: "Please enter category description", trigger: "blur" },
        ],
      },
      queryInfo: {
        pageNum: 1,
        pageSize: 5,
      },
      total: 0,
      title: "Book Categories",
      json_fields: {
        "Category ID": "typeId",
        "Category Name": "typeName",
        "Category Description": "typeContent",
      },
      loading: true
    };
  },
  methods: {
    handleSizeChange(val) {
      this.queryInfo.pageSize = val;
      this.getBookTypeList();
    },
    handleCurrentChange(val) {
      this.queryInfo.pageNum = val;
      this.getBookTypeList();
    },
    // Show edit dialog and populate data from database
    async showEditDialog(id) {
      this.editDialogVisible = true;
      const { data: res } = await this.$http.get("admin/get_booktype/" + id);
      console.log(res);
      if (res.status !== 200) {
        return this.$message.error(res.msg);
      }
      this.editForm = res.data;
    },
    // Reset form when edit dialog is closed
    editDialogClosed() {
      this.$refs.editFormRef.resetFields();
    },
    // Delete category
    async removeUserById(id) {
      // Confirm deletion with user
      const confirmResult = await this.$confirm(
        "This will permanently delete this category. Continue?",
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
      // Send delete request
      const { data: res } = await this.$http.get('admin/delete_booktype/' + id)
      console.log(res);
      if (res.status !== 200) {
        return this.$message.error(res.msg);
      }
      this.$message.success(res.msg)
      // Reset pagination and refresh list
      this.queryInfo.pageNum = 1;
      this.queryInfo.pageSize = 5;
      this.getBookTypeList();
    },
    // Reset form when add dialog is closed
    addDialogClosed() {
      this.$refs.addFormRef.resetFields();
    },
    // Show add dialog
    showAddDialog() {
      this.addDialogVisible = true;
    },
    async getBookTypeList() {
      this.loading = true;
      const { data: res } = await this.$http.post(
        "admin/get_booktype_page",
        this.queryInfo
      );
      if (res.status !== 200) {
        this.loading = false;
        return this.$message.error(res.msg);
      }
      this.$message.success(
        {
          message: res.msg,
          duration: 1000
        }
      )
      this.tableData = res.data.records;
      this.total = parseInt(res.data.total);
      this.loading = false;
    },
    async addBookType() {
      this.$refs.addFormRef.validate(async (valid) => {
        if (!valid) {
          return;
        }
        // Send add request
        const { data: res } = await this.$http.post(
          "admin/add_booktype",
          this.addForm
        );
        if (res.status !== 200) {
          return this.$message.error(res.msg);
        }
        this.$message.success({
          message: res.msg,
          duration: 1500,
        });
        this.getBookTypeList();
        this.addDialogVisible = false;
      });
    },
    async updateBookType() {
      const { data: res } = await this.$http.post('admin/update_booktype', this.editForm)
      console.log(res);
      if (res.status !== 200) {
        return this.$message.error(res.msg);
      }
      this.$message.success({
        message: res.msg,
        duration: 1500
      })
      this.getBookTypeList();
      this.editDialogVisible = false;
    },
    downLoad() {
      this.getPdf(this.title); // Parameter is PDF filename
    },
    fullScreen() {
      // Toggle fullscreen mode
      let full = document.fullscreenElement;
      if (!full) {
        document.documentElement.requestFullscreen();
      } else {
        document.exitFullscreen();
      }
    }
  },
  created() {
    this.getBookTypeList();
  },
};
</script>

<style></style>