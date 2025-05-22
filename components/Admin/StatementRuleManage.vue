<template>
  <div class="search_container">
    <!-- Breadcrumb Navigation -->
    <el-breadcrumb separator-class="el-icon-arrow-right">
      <el-breadcrumb-item>Home</el-breadcrumb-item>
      <el-breadcrumb-item>Borrowing Rule Management</el-breadcrumb-item>
    </el-breadcrumb>
    <el-card shadow="always">
      <!-- Search and Export Area -->
      <el-row>
        <el-col :span="4">
          <el-button type="primary" @click="showAddDialog()">
            <i class="el-icon-plus"></i> Add</el-button>
        </el-col>
        <el-col :span="2" style="float: right">
          <download-excel class="export-excel-wrapper" :data="tableData" :fields="json_fields" :header="title"
            name="Borrowing Rules.xls">
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
        :default-sort="{ prop: 'bookRuleId', order: 'ascending' }" v-loading="loading" element-loading-text="拼命加载中"
        element-loading-spinner="el-icon-loading" element-loading-background="rgba(0, 0, 0, 0.8)">
        <el-table-column prop="bookRuleId" label="ID" sortable> </el-table-column>
        <el-table-column prop="bookDays" label="Day Limit" sortable> </el-table-column>
        <el-table-column prop="bookLimitNumber" label="Book Limit" sortable>
        </el-table-column>
        <el-table-column prop="bookLimitLibrary" label="Library Restrictions">
        </el-table-column>
        <el-table-column prop="bookOverdueFee" label="Overdue Fee" sortable>
        </el-table-column>
        <el-table-column label="Operations">
          <template slot-scope="scope">
            <!-- Edit Button -->
            <el-tooltip effect="dark" content="Edit" placement="top" :enterable="false">
              <el-button type="primary" icon="el-icon-edit" size="mini"
                @click="showEditDialog(scope.row.ruleId)"></el-button></el-tooltip>

            <!-- Delete Button -->
            <el-tooltip effect="dark" content="Delete" placement="top" :enterable="false">
              <el-button type="danger" icon="el-icon-delete" size="mini"
                @click="removeUserById(scope.row.ruleId)"></el-button>
            </el-tooltip>
          </template>
        </el-table-column>
      </el-table>
      <!-- Pagination Area -->
      <el-pagination @size-change="handleSizeChange" @current-change="handleCurrentChange"
        :current-page="queryInfo.pageNum" :page-sizes="[1, 2, 3, 4, 5]" :page-size="queryInfo.pageSize"
        layout="total, sizes, prev, pager, next, jumper" :total="this.total">
      </el-pagination>
      <!-- Edit Rule Dialog -->
      <el-dialog title="Edit Rule" :visible.sync="editDialogVisible" width="50%" @close="editDialogClosed">
        <el-form :model="editForm" ref="editFormRef" :rules="editFormRules" label-width="120px">
          <el-form-item label="Day Limit" prop="bookDays">
            <el-input v-model="editForm.bookDays"></el-input>
          </el-form-item>
          <el-form-item label="Book Limit" prop="bookLimitNumber">
            <el-input v-model="editForm.bookLimitNumber"></el-input>
          </el-form-item>
          <el-form-item label="Library Restrictions">
            <el-checkbox-group v-model="editForm.checkList">
              <el-checkbox label="South Library"></el-checkbox>
              <el-checkbox label="North Library"></el-checkbox>
              <el-checkbox label="Teachers' Lounge"></el-checkbox>
            </el-checkbox-group>
          </el-form-item>
          <el-form-item label="Daily Overdue Fee" prop="bookOverdueFee">
            <el-input v-model="editForm.bookOverdueFee"></el-input>
          </el-form-item>
        </el-form>
        <span slot="footer" class="dialog-footer">
          <el-button @click="editDialogVisible = false">Cancel</el-button>
          <el-button type="primary" @click="updateRule">Confirm</el-button>
        </span>
      </el-dialog>
      <!-- Add Rule Dialog -->
      <el-dialog title="Add Rule" :visible.sync="addDialogVisible" width="50%" @close="addDialogClosed">
        <el-form :model="addForm" ref="addFormRef" :rules="addFormRules" label-width="120px">
          <el-form-item label="Day Limit" prop="bookDays">
            <el-input v-model="addForm.bookDays"></el-input>
          </el-form-item>
          <el-form-item label="Book Limit" prop="bookLimitNumber">
            <el-input v-model="addForm.bookLimitNumber"></el-input>
          </el-form-item>
          <el-form-item label="Library Restrictions">
            <el-checkbox-group v-model="addForm.checkList">
              <el-checkbox label="South Library"></el-checkbox>
              <el-checkbox label="North Library"></el-checkbox>
              <el-checkbox label="Teachers' Lounge"></el-checkbox>
            </el-checkbox-group>
          </el-form-item>
          <el-form-item label="Daily Overdue Fee" prop="bookOverdueFee">
            <el-input v-model="addForm.bookOverdueFee"></el-input>
          </el-form-item>
        </el-form>
        <span slot="footer" class="dialog-footer">
          <el-button @click="addDialogVisible = false">Cancel</el-button>
          <el-button type="primary" @click="addRule">Add Rule</el-button>
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
          bookRuleId: 183,
          bookDays: 60,
          bookLimitNumber: 1000,
          bookLimitLibrary: "1、2、3",
          bookOverdueFee: 3.0,
        },
        {
          bookRuleId: 183,
          bookDays: 60,
          bookLimitNumber: 1000,
          bookLimitLibrary: "1、2、3",
          bookOverdueFee: 3.0,
        },
        {
          bookRuleId: 183,
          bookDays: 60,
          bookLimitNumber: 1000,
          bookLimitLibrary: "1、2、3",
          bookOverdueFee: 3.0,
        },
        {
          bookRuleId: 183,
          bookDays: 60,
          bookLimitNumber: 1000,
          bookLimitLibrary: "1、2、3",
          bookOverdueFee: 3.0,
        },
      ],

      editDialogVisible: false,
      editForm: {
        bookDays: "",
        bookLimitNumber: "",
        checkList: ["South Library", "North Library", "Teachers' Lounge"],
        bookOverdueFee: 0,
        bookLimitLibrary: "",
      },
      editFormRules: {
        bookLimitDays: [
          { required: true, message: "Please enter day limit", trigger: "blur" },
        ],
        bookLimitNumber: [
          { required: true, message: "Please enter book limit", trigger: "blur" },
        ],
        bookOverdueFee: [
          {
            required: true,
            message: "Please enter correct daily overdue fee",
            trigger: "blur",
          },
        ],
      },
      addDialogVisible: false,
      addForm: {
        bookDays: "",
        bookLimitNumber: "",
        checkList: ["South Library", "North Library", "Teachers' Lounge"],
        bookOverdueFee: 0,
        bookLimitLibrary: "",
      },
      addFormRules: {
        bookLimitDays: [
          { required: true, message: "Please enter day limit", trigger: "blur" },
        ],
        bookLimitNumber: [
          { required: true, message: "Please enter book limit", trigger: "blur" },
        ],
        bookOverdueFee: [
          {
            required: true,
            message: "Please enter correct daily overdue fee",
            trigger: "blur",
          },
        ],
      },
      queryInfo: {
        pageNum: 1,
        pageSize: 5,
      },
      total: 0,
      title: "Borrowing Rules",
      json_fields: {
        "Rule ID": "bookRuleId",
        "Day Limit": "bookDays",
        "Book Limit": "bookLimitNumber",
        "Library Restrictions": "bookLimitLibrary",
        "Overdue Fee": "bookOverdueFee",
      },
      loading: true
    };
  },
  methods: {
    handleSizeChange(val) {
      this.queryInfo.pageSize = val;
      this.getRuleList();
    },
    handleCurrentChange(val) {
      this.queryInfo.pageNum = val;
      this.getRuleList();
    },
    // Show edit dialog and populate data from database
    async showEditDialog(id) {
      const { data: res } = await this.$http.get('admin/get_rule_ruleid/' + id)
      if (res.status !== 200) {
        return this.$message.error(res.msg);
      }

      this.editForm = res.data
      this.editDialogVisible = true;
    },
    // Reset form when edit dialog is closed
    editDialogClosed() {
      this.$refs.editFormRef.resetFields();
      this.editForm.checkList = ["South Library", "North Library", "Teachers' Lounge"];
    },
    // Delete rule
    async removeUserById(id) {
      // Confirm deletion with user
      const confirmResult = await this.$confirm(
        "This will permanently delete this rule. Continue?",
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
      const { data: res } = await this.$http.delete('admin/delete_rule/' + id);
      if (res.status !== 200) {
        return this.$message.error(res.msg);
      }
      this.$message.success({
        message: res.msg,
        duration: 1500,
      });
      this.getRuleList();
    },
    // Reset form when add dialog is closed
    addDialogClosed() {
      this.$refs.addFormRef.resetFields();
      this.addForm.checkList = ["South Library", "North Library", "Teachers' Lounge"];
    },
    // Show add dialog
    showAddDialog() {
      this.addDialogVisible = true;
    },
    async getRuleList() {
      this.loading = true;
      const { data: res } = await this.$http.post(
        "admin/get_rulelist_page",
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
    async addRule() {
      const libraryList = this.addForm.checkList.join(',')
      this.addForm.bookLimitLibrary = libraryList;
      const { data: res } = await this.$http.post(
        "admin/add_rule",
        this.addForm
      );
      if (res.status !== 200) {
        return this.$message.error(res.msg);
      }
      this.$message.success({
        message: res.msg,
        duration: 1500,
      });
      this.addDialogVisible = false;
      this.getRuleList();
    },
    async updateRule() {
      const { data: res } = await this.$http.put('admin/update_rule', this.editForm)
      if (res.status !== 200) {
        return this.$message.error(res.msg);
      }
      this.$message.success({
        message: res.msg,
        duration: 1500,
      });
      this.getRuleList();
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
    this.getRuleList();
  },
};
</script>

<style></style>