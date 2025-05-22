<template>
  <div class="search_container">
    <!-- Breadcrumb Navigation -->
    <el-breadcrumb separator-class="el-icon-arrow-right">
      <el-breadcrumb-item>Home</el-breadcrumb-item>
      <el-breadcrumb-item>Library Card Management</el-breadcrumb-item>
    </el-breadcrumb>
    <el-card shadow="always">
      <!-- Search and Export Area -->
      <el-row :gutter="10">
        <el-col :span="6">Condition Search:<el-select v-model="queryInfo.condition" filterable
            placeholder="Please select" style="margin-left: 15px">
            <el-option v-for="item in searchs" :key="item.value" :label="item.label" :value="item.value">
            </el-option>
          </el-select>
        </el-col>
        <el-col :span="4">
          <el-input placeholder="Please input" v-model="queryInfo.query" class="input-with-select"
            @keyup.enter.native="getStatementList">
            <el-button slot="append" icon="el-icon-search" @click="getStatementList"></el-button> </el-input></el-col>
        <el-col :span="4">
          <el-button type="primary" @click="showAddDialog()">
            <i class="el-icon-plus"></i> Add Library Card</el-button>
        </el-col>
        <el-col :span="2" style="float: right">
          <download-excel class="export-excel-wrapper" :data="tableData" :fields="json_fields" :header="title"
            name="Library Card Management.xls">
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
        :default-sort="{ prop: 'cardNumber', order: 'ascending' }" v-loading="loading" element-loading-text="拼命加载中"
        element-loading-spinner="el-icon-loading" element-loading-background="rgba(0, 0, 0, 0.8)">
        <el-table-column prop="cardNumber" label="Card Number" sortable>
        </el-table-column>
        <el-table-column prop="username" label="Username"> </el-table-column>
        <el-table-column prop="ruleNumber" label="Borrowing Rule" sortable> </el-table-column>
        <el-table-column prop="status" label="Status" sortable> </el-table-column>
        <el-table-column label="Operations">
          <template slot-scope="scope">
            <!-- Edit Button -->
            <el-tooltip effect="dark" content="Edit" placement="top" :enterable="false">
              <el-button type="primary" icon="el-icon-edit" size="mini"
                @click="showEditDialog(scope.row.userId)"></el-button></el-tooltip>

            <!-- Delete Button -->
            <el-tooltip effect="dark" content="Delete" placement="top" :enterable="false">
              <el-button type="danger" icon="el-icon-delete" size="mini"
                @click="removeUserById(scope.row.userId)"></el-button>
            </el-tooltip>
          </template>
        </el-table-column>
      </el-table>
      <!-- Pagination Area -->
      <el-pagination @size-change="handleSizeChange" @current-change="handleCurrentChange"
        :current-page="queryInfo.pageNum" :page-sizes="[1, 2, 3, 4, 5]" :page-size="queryInfo.pageSize"
        layout="total, sizes, prev, pager, next, jumper" :total="this.total">
      </el-pagination>
      <!-- Edit Dialog -->
      <el-dialog title="Edit Library Card" :visible.sync="editDialogVisible" width="50%" @close="editDialogClosed">
        <el-form :model="editForm" ref="editFormRef" :rules="editFormRules" label-width="120px">
          <el-form-item label="Username" prop="username">
            <el-input v-model="editForm.username"></el-input>
          </el-form-item>
          <el-form-item label="Password" prop="password">
            <el-input v-model="editForm.password" type="password"></el-input>
          </el-form-item>
          <el-form-item label="Rule" prop="ruleNumber">
            <el-select v-model="editForm.ruleNumber" placeholder="Please select">
              <el-option v-for="item in bookRuleIdLists" :key="item.ruleId" :label="item.bookRuleId"
                :value="item.bookRuleId">
              </el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="Status" prop="userStatus">
            <el-radio-group v-model="editForm.userStatus">
              <el-radio label="Active">Active</el-radio>
              <el-radio label="Lost">Lost</el-radio>
            </el-radio-group>
          </el-form-item>
        </el-form>
        <span slot="footer" class="dialog-footer">
          <el-button @click="editDialogVisible = false">Cancel</el-button>
          <el-button type="primary" @click="updateStatement">Confirm</el-button>
        </span>
      </el-dialog>
      <!-- Add Dialog -->
      <el-dialog title="Add Library Card" :visible.sync="addDialogVisible" width="50%" @close="addDialogClosed">
        <el-form :model="addForm" ref="addFormRef" :rules="addFormRules" label-width="120px">
          <el-form-item label="Username" prop="username">
            <el-input v-model="addForm.username"></el-input>
          </el-form-item>
          <el-form-item label="Password" prop="password">
            <el-input v-model="addForm.password"></el-input>
          </el-form-item>
          <el-form-item label="Rule" prop="ruleNumber">
            <el-select v-model="addForm.ruleNumber" placeholder="Please select">
              <el-option v-for="item in bookRuleIdLists" :key="item.ruleId" :label="item.bookRuleId"
                :value="item.bookRuleId">
              </el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="Status" prop="userStatus">
            <el-radio-group v-model="addForm.userStatus">
              <el-radio label="Active">Active</el-radio>
              <el-radio label="Disabled">Disabled</el-radio>
            </el-radio-group>
          </el-form-item>
        </el-form>
        <span slot="footer" class="dialog-footer">
          <el-button @click="addDialogVisible = false">Cancel</el-button>
          <el-button type="primary" @click="addStatement">Add Library Card</el-button>
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
        ruleNumber: "",
        status: "",
        userStatus: "",
      },
      editFormRules: {},
      addDialogVisible: false,
      addForm: {
        username: "",
        password: "",
        ruleNumber: "",
        userStatus: "",
      },
      addFormRules: {},
      searchs: [
        {
          value: "card_number",
          label: "Card Number",
        },
        {
          value: "username",
          label: "Username",
        },
        {
          value: "rule_number",
          label: "Borrowing Rule",
        },
        {
          value: "status",
          label: "Status",
        },
      ],
      bookRuleIdLists: [
        {
          ruleId: "18",
          bookRuleId: "18",
        },
        {
          ruleId: "357",
          bookRuleId: "357",
        },
      ],
      queryInfo: {
        pageNum: 1,
        pageSize: 5,
        condition: "",
        query: "",
      },
      total: 0,
      title: "Library Card Management",
      json_fields: {
        "Card Number": "cardNumber",
        "Username": "username",
        "Borrowing Rule": "ruleNumber",
        "Status": "status",
      },
      loading: true
    };
  },
  methods: {
    handleSizeChange(val) {
      this.queryInfo.pageSize = val;
      this.getStatementList();
    },
    handleCurrentChange(val) {
      this.queryInfo.pageNum = val;
      this.getStatementList();
    },
    // Show edit dialog and populate data from database
    async showEditDialog(id) {
      const { data: res } = await this.$http.get("admin/get_statement/" + id);
      if (res.status !== 200) {
        return this.$message.error(res.msg);
      }
      // Get rule list
      const { data: res2 } = await this.$http.get("user/get_rulelist");
      this.bookRuleIdLists = res2.data;
      this.editForm = res.data;
      this.editDialogVisible = true;
    },
    // Reset form when edit dialog is closed
    editDialogClosed() {
      this.$refs.editFormRef.resetFields();
    },
    // Delete library card
    async removeUserById(id) {
      // Confirm deletion with user
      const confirmResult = await this.$confirm(
        "This will permanently delete this library card. Continue?",
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
      const { data: res } = await this.$http.delete(
        "admin/delete_statement/" + id
      );
      console.log(res);
      if (res.status !== 200) {
        return this.$message.error(res.msg);
      }
      this.$message.success(res.msg);
      this.getStatementList();
    },
    // Reset form when add dialog is closed
    addDialogClosed() {
      this.$refs.addFormRef.resetFields();
    },
    // Show add dialog
    async showAddDialog() {
      // Get rule list
      const { data: res } = await this.$http.get("user/get_rulelist");
      this.bookRuleIdLists = res.data;
      this.addDialogVisible = true;
    },
    async getStatementList() {
      this.loading = true;
      const { data: res } = await this.$http.post(
        "admin/get_statementlist",
        this.queryInfo
      );
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
    async addStatement() {
      const { data: res } = await this.$http.post(
        "admin/add_statement",
        this.addForm
      );
      if (res.status !== 200) {
        return this.$message.error(res.msg);
      }

      this.$message.success(res.msg);
      this.addDialogVisible = false;
      this.getStatementList();
    },
    async updateStatement() {
      const { data: res } = await this.$http.post(
        "admin/update_statement",
        this.editForm
      );
      if (res.status !== 200) {
        return this.$message.error(res.msg);
      }
      this.$message.success(res.msg);
      this.getStatementList();
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
    this.getStatementList();
  },
};
</script>

<style></style>