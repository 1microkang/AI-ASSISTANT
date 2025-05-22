<template>
  <div class="search_container">
    <!-- Breadcrumb Navigation -->
    <el-breadcrumb separator-class="el-icon-arrow-right">
      <el-breadcrumb-item>Home</el-breadcrumb-item>
      <el-breadcrumb-item>Violation Records</el-breadcrumb-item>
    </el-breadcrumb>
    <el-card shadow="always">
      <!-- Search and Export Area -->
      <el-row>
        <el-col :span="6">Search by:<el-select v-model="queryInfo.condition" filterable placeholder="Please select"
            style="margin-left: 15px">
            <el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value">
            </el-option>
          </el-select>
        </el-col>
        <el-col :span="4">
          <el-input placeholder="Please enter" v-model="queryInfo.query" class="input-with-select"
            @keyup.enter.native="searchViolationByPage">
            <el-button slot="append" icon="el-icon-search" @click="searchViolationByPage"></el-button>
          </el-input></el-col>
        <el-col :span="2" style="float: right">
          <download-excel class="export-excel-wrapper" :data="tableData" :fields="json_fields" :header="title"
            name="Book_Violation_Records.xls">
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
        :default-sort="{ prop: 'cardNumber', order: 'ascending' }" v-loading="loading" element-loading-text="Loading..."
        element-loading-spinner="el-icon-loading" element-loading-background="rgba(0, 0, 0, 0.8)">
        <el-table-column prop="cardNumber" label="Library Card No." sortable> </el-table-column>
        <el-table-column prop="bookNumber" label="Book ID" sortable> </el-table-column>
        <el-table-column prop="borrowDate" label="Borrow Date" sortable> </el-table-column>
        <el-table-column prop="closeDate" label="Due Date" sortable> </el-table-column>
        <el-table-column prop="returnDate" label="Return Date" sortable> </el-table-column>
        <el-table-column prop="violationMessage" label="Violation Details">
        </el-table-column>
        <el-table-column prop="violationAdmin" label="Processed By">
        </el-table-column>
      </el-table>
      <!-- Pagination Area -->
      <el-pagination @size-change="handleSizeChange" @current-change="handleCurrentChange"
        :current-page="this.queryInfo.pageNum" :page-sizes="[1, 2, 3, 4, 5]" :page-size="this.queryInfo.pageSize"
        layout="total, sizes, prev, pager, next, jumper" :total="this.total">
      </el-pagination>
    </el-card>
  </div>
</template>

<script>
export default {
  data() {
    return {
      options: [
        {
          value: "book_number",
          label: "Book ID",
        },
        {
          value: "borrow_date",
          label: "Borrow Date",
        },
        {
          value: "close_date",
          label: "Due Date",
        },
        {
          value: "return_date",
          label: "Return Date",
        },
        {
          value: "violation_message",
          label: "Violation Details",
        },
      ],
      tableData: [
        {
          cardNumber: Number,
          bookNumber: Number,
          borrowDate: "",
          closeDate: "",
          returnDate: "",
          violationMessage: "",
          violationAdmin: "",
        },
      ],
      queryInfo: {
        pageNum: 1,
        pageSize: 5,
        condition: "",
        query: "",
        cardNumber: window.sessionStorage.getItem("cardNumber"),
      },
      total: 0,
      title: "Book Violation Records",
      json_fields: {
        "Library Card No.": "cardNumber",
        "Book ID": "bookNumber",
        "Borrow Date": "borrowDate",
        "Due Date": "closeDate",
        "Return Date": "returnDate",
        "Violation Details": "violationMessage",
        "Processed By": "violationAdmin"
      },
      loading: true
    };
  },
  methods: {
    handleSizeChange(val) {
      this.queryInfo.pageSize = val;
      this.searchViolationByPage();
    },
    handleCurrentChange(val) {
      this.queryInfo.pageNum = val;
      this.searchViolationByPage();
    },
    async searchViolationByPage() {
      this.loading = true;
      const { data: res } = await this.$http.post(
        "user/get_violation",
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
    downLoad() {
      this.getPdf(this.title); // Parameter is PDF filename
    },
    fullScreen() {
      let full = document.fullscreenElement;
      if (!full) {
        document.documentElement.requestFullscreen();
      } else {
        document.exitFullscreen();
      }
    }
  },
  created() {
    this.searchViolationByPage();
  },
};
</script>

<style></style>