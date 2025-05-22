<template>
  <div class="search_container">
    <!-- Breadcrumb navigation area -->
    <el-breadcrumb separator-class="el-icon-arrow-right">
      <el-breadcrumb-item>Home</el-breadcrumb-item>
      <el-breadcrumb-item>Book Search</el-breadcrumb-item>
    </el-breadcrumb>
    <el-card shadow="always">
      <!-- Search and export area -->
      <el-row>
        <el-col :span="6">Search:
          <el-select v-model="queryInfo.condition" filterable placeholder="Please select" style="margin-left: 15px">
            <el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value">
            </el-option>
          </el-select>
        </el-col>
        <el-col :span="4">
          <el-input placeholder="Please enter" v-model="queryInfo.query" class="input-with-select"
            @keyup.enter.native="searchBookByPage">
            <el-button slot="append" icon="el-icon-search" @click="searchBookByPage"></el-button>
          </el-input>
        </el-col>
        <el-col :span="2" style="float: right">
          <download-excel class="export-excel-wrapper" :data="tableData" :fields="json_fields" :header="title"
            name="Book_Search_List.xls">
            <!-- You can customize your own style above and reference other component buttons -->
            <el-button type="primary" class="el-icon-printer" size="mini">Export Excel
            </el-button>
          </download-excel>
        </el-col>
        <el-col :span="2" style="float: right">
          <el-button type="primary" class="el-icon-printer" size="mini" @click="downLoad">Export PDF
          </el-button>
        </el-col>
        <el-col :span="2" style="float: right">
          <el-button type="success" class="el-icon-full-screen" size="mini" @click="fullScreen">Full Screen
          </el-button>
        </el-col>
      </el-row>
      <!-- Table area -->
      <el-table :data="tableData" height="520" border style="width: 100%; font-size: 14px" v-loading="loading"
        element-loading-text="Loading..." element-loading-spinner="el-icon-loading"
        element-loading-background="rgba(0, 0, 0, 0.8)" id="pdfDom"
        :default-sort="{ prop: 'bookNumber', order: 'ascending' }" stripe>
        <el-table-column prop="bookNumber" label="Book Number" sortable></el-table-column>
        <el-table-column prop="bookName" label="Book Name"></el-table-column>
        <el-table-column prop="bookAuthor" label="Author"></el-table-column>
        <el-table-column prop="bookLibrary" label="Library"></el-table-column>
        <el-table-column prop="bookType" label="Category"></el-table-column>
        <el-table-column prop="bookLocation" label="Location" sortable></el-table-column>
        <el-table-column prop="bookStatus" label="Status" sortable></el-table-column>
        <el-table-column prop="bookDescription" label="Description" width="600px">
        </el-table-column>
      </el-table>
      <!-- Pagination area -->
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
          label: "Book Number",
        },
        {
          value: "book_name",
          label: "Book Name",
        },
        {
          value: "book_author",
          label: "Author",
        },
        {
          value: "book_location",
          label: "Location",
        },
        {
          value: "book_description",
          label: "Description",
        },
      ],
      tableData: [],
      queryInfo: {
        pageNum: 1,
        pageSize: 5,
        condition: "",
        query: "",
      },
      total: 0,

      title: "Book Search List",
      json_fields: {
        "Book Number": "bookNumber",
        "Book Name": "bookName",
        "Author": "bookAuthor",
        "Library": "bookLibrary",
        "Category": "bookType",
        "Location": "bookLocation",
        "Status": "bookStatus",
        "Description": "bookDescription",
      },
      loading: true,
    };
  },
  created() {
    this.searchBookByPage();
  },
  methods: {
    handleSizeChange(val) {
      this.queryInfo.pageSize = val;
      this.searchBookByPage();
    },
    handleCurrentChange(val) {
      this.queryInfo.pageNum = val;
      this.searchBookByPage();
    },
    async searchBookByPage() {
      this.loading = true;
      const { data: res } = await this.$http.post(
        "user/search_book_page",
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
      this.loading = false;
      this.tableData = res.data.records;
      this.total = parseInt(res.data.total);
    },
    downLoad() {
      this.getPdf(this.title); //Parameter is the name of the downloaded pdf file
    },
    fullScreen() {
      // A DOM property: can be used to determine whether it's currently in full screen mode (true or false)
      let full = document.fullscreenElement;
      // Switch to full screen mode
      if (!full) {
        // Document root node's requestFullscreen method to enable full screen mode
        document.documentElement.requestFullscreen();
      } else {
        // Exit full screen mode
        document.exitFullscreen();
      }
    },
  },
};
</script>

<style lang="css"></style>