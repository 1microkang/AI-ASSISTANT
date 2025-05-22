<template>
  <div class="search_container">
    <!-- Breadcrumb Navigation -->
    <el-breadcrumb separator-class="el-icon-arrow-right">
      <el-breadcrumb-item>Home</el-breadcrumb-item>
      <el-breadcrumb-item>Book Management</el-breadcrumb-item>
    </el-breadcrumb>
    <el-card shadow="always">
      <!-- Search and Export Area -->
      <el-row :gutter="10">
        <el-col :span="6">Search:<el-select v-model="queryInfo.condition" filterable placeholder="Please select"
            style="margin-left: 15px">
            <el-option v-for="item in searchs" :key="item.value" :label="item.label" :value="item.value">
            </el-option>
          </el-select>
        </el-col>
        <el-col :span="4">
          <el-input placeholder="Please input" v-model="queryInfo.query" class="input-with-select"
            @keyup.enter.native="getBookList">
            <el-button slot="append" icon="el-icon-search" @click="getBookList"></el-button> </el-input></el-col>
        <el-col :span="2">
          <el-button type="primary" @click="showAddDialog()" size="default">
            <i class="el-icon-plus"></i> Add</el-button>
        </el-col>
        <el-col :span="3" style="float:right">
          <el-upload class="upload-demo" ref="upload" name="files" action="http://localhost:8889/api/admin/updown"
            :on-preview="handlePreview" :on-remove="handleRemove" :headers="headers" :file-list="fileList"
            :on-success="onSuccess" :auto-upload="false">
            <el-button slot="trigger" size="mini" type="primary" title="Import books from Excel">Select File</el-button>
            <el-button size="mini" type="success" @click="submitUpload" style="margin-left: 5px;">Upload</el-button>
          </el-upload>
        </el-col>
        <el-col :span="2" style="float: right">
          <download-excel class="export-excel-wrapper" :data="tableData" :fields="json_fields" :header="title"
            name="Book Management.xls">
            <el-button type="primary" class="el-icon-printer" size="mini">Export Excel</el-button>
          </download-excel>
        </el-col>
        <el-col :span="2" style="float: right">
          <el-button type="primary" class="el-icon-printer" size="mini" @click="downLoad">Export PDF</el-button>
        </el-col>
        <el-col :span="2" style="float: right">
          <el-button type="warning" @click="removeBatch()" size="mini">
            <i class="el-icon-delete"></i>Delete</el-button>
        </el-col>
        <el-col :span="2" style="float: right">
          <el-button type="success" class="el-icon-full-screen" size="mini" @click="fullScreen">Full</el-button>
        </el-col>
      </el-row>

      <!-- Table Area -->
      <el-table :data="tableData" border height="520" style="width: 100%" stripe id="pdfDom"
        :default-sort="{ prop: 'bookNumber', order: 'ascending' }" v-loading="loading" element-loading-text="拼命加载中"
        element-loading-spinner="el-icon-loading" element-loading-background="rgba(0, 0, 0, 0.8)"
        @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55"> </el-table-column>
        <el-table-column type="index"></el-table-column>
        <el-table-column prop="bookNumber" label="Book ID" sortable>
        </el-table-column>
        <el-table-column prop="bookName" label="Title" width="80px">
        </el-table-column>
        <el-table-column prop="bookAuthor" label="Author" width="80px">
        </el-table-column>
        <el-table-column prop="bookLibrary" label="Library" width="80px">
        </el-table-column>
        <el-table-column prop="bookType" label="Category" width="80px">
        </el-table-column>
        <el-table-column prop="bookLocation" label="Location" sortable width="80px">
        </el-table-column>
        <el-table-column prop="bookStatus" label="Status" sortable width="80px">
        </el-table-column>
        <el-table-column prop="bookDescription" label="Description" width="400px">
        </el-table-column>
        <el-table-column label="Operations">
          <template slot-scope="scope">
            <!-- Edit Button -->
            <el-tooltip effect="dark" content="Edit" placement="top" :enterable="false">
              <el-button type="primary" icon="el-icon-edit" size="mini"
                @click="showEditDialog(scope.row.bookId)"></el-button></el-tooltip>

            <!-- Delete Button -->
            <el-tooltip effect="dark" content="Delete" placement="top" :enterable="false">
              <el-button type="danger" icon="el-icon-delete" size="mini"
                @click="removeUserById(scope.row.bookId)"></el-button>
            </el-tooltip>
          </template>
        </el-table-column>
      </el-table>
      <!-- Pagination Area -->
      <el-pagination @size-change="handleSizeChange" @current-change="handleCurrentChange"
        :current-page="queryInfo.pageNum" :page-sizes="[1, 2, 3, 4, 5]" :page-size="queryInfo.pageSize"
        layout="total, sizes, prev, pager, next, jumper" :total="this.total">
      </el-pagination>
      <!-- Edit Book Dialog -->
      <el-dialog title="Edit Book" :visible.sync="editDialogVisible" width="50%" @close="editDialogClosed">
        <el-form :model="editForm" ref="editFormRef" :rules="editFormRules" label-width="120px">
          <el-form-item label="Title" prop="bookName">
            <el-input v-model="editForm.bookName"></el-input>
          </el-form-item>
          <el-form-item label="Author" prop="bookAuthor">
            <el-input v-model="editForm.bookAuthor"></el-input>
          </el-form-item>
          <el-form-item label="Library">
            <el-radio-group v-model="editForm.bookLibrary">
              <el-radio-button label="South Library"></el-radio-button>
              <el-radio-button label="North Library"></el-radio-button>
              <el-radio-button label="Teachers' Lounge"></el-radio-button>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="Category">
            <el-select v-model="editForm.bookType" placeholder="Please select">
              <el-option v-for="item in types" :key="item.typeId" :label="item.typeName" :value="item.typeId">
              </el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="Location" prop="bookLocation">
            <el-input v-model="editForm.bookLocation"></el-input>
          </el-form-item>
          <el-form-item label="Status" prop="bookStatus">
            <el-radio-group v-model="editForm.bookStatus">
              <el-radio label="Checked Out">Checked Out</el-radio>
              <el-radio label="Available">Available</el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="Description" prop="bookDescription">
            <el-input type="textarea" v-model="editForm.bookDescription"></el-input>
          </el-form-item>
        </el-form>
        <span slot="footer" class="dialog-footer">
          <el-button @click="editDialogVisible = false">Cancel</el-button>
          <el-button type="primary" @click="updateBook">Confirm</el-button>
        </span>
      </el-dialog>
      <!-- Add Book Dialog -->
      <el-dialog title="Add Book" :visible.sync="addDialogVisible" width="50%" @close="addDialogClosed">
        <el-form :model="addForm" ref="addFormRef" :rules="addFormRules" label-width="120px">
          <el-form-item label="Title" prop="bookName">
            <el-input v-model="addForm.bookName"></el-input>
          </el-form-item>
          <el-form-item label="Author" prop="bookAuthor">
            <el-input v-model="addForm.bookAuthor"></el-input>
          </el-form-item>
          <el-form-item label="Library">
            <el-radio-group v-model="addForm.bookLibrary">
              <el-radio-button label="South Library"></el-radio-button>
              <el-radio-button label="North Library"></el-radio-button>
              <el-radio-button label="Teachers' Lounge"></el-radio-button>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="Category">
            <el-select v-model="addForm.bookTypeNumber" placeholder="Please select">
              <el-option v-for="item in types" :key="item.typeId" :label="item.typeName" :value="item.typeId">
              </el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="Location" prop="bookLocation">
            <el-input v-model="addForm.bookLocation"></el-input>
          </el-form-item>
          <el-form-item label="Status" prop="bookStatus">
            <el-radio-group v-model="addForm.bookStatus">
              <el-radio label="Checked Out">Checked Out</el-radio>
              <el-radio label="Available">Available</el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="Description" prop="bookDescription">
            <el-input type="textarea" v-model="addForm.bookDescription"></el-input>
          </el-form-item>
        </el-form>
        <span slot="footer" class="dialog-footer">
          <el-button @click="addDialogVisible = false">Cancel</el-button>
          <el-button type="primary" @click="addBook">Add Book</el-button>
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
        bookName: "",
        bookAuthor: "",
        bookLibrary: "South Library",
        bookType: "",
        bookLocation: "",
        bookStatus: "",
        bookDescription: "",
      },
      editFormRules: {
        bookName: [
          { required: true, message: "Book title cannot be empty", trigger: "blur" },
        ],
        bookAuthor: [
          { required: true, message: "Author cannot be empty", trigger: "blur" },
        ],
        bookLocation: [
          { required: true, message: "Location cannot be empty", trigger: "blur" },
        ],
        bookDescription: [
          { required: true, message: "Description cannot be empty", trigger: "blur" },
        ],
      },
      addDialogVisible: false,
      addForm: {
        bookName: "",
        bookAuthor: "",
        bookLibrary: "South Library",
        bookTypeNumber: "",
        bookLocation: "",
        bookStatus: "",
        bookDescription: "",
      },
      addFormRules: {
        bookName: [
          { required: true, message: "Book title cannot be empty", trigger: "blur" },
        ],
        bookAuthor: [
          { required: true, message: "Author cannot be empty", trigger: "blur" },
        ],
        bookLocation: [
          { required: true, message: "Location cannot be empty", trigger: "blur" },
        ],
        bookDescription: [
          { required: true, message: "Description cannot be empty", trigger: "blur" },
        ],
      },
      searchs: [
        {
          value: "book_number",
          label: "Book ID",
        },
        {
          value: "book_name",
          label: "Title",
        },
        {
          value: "book_author",
          label: "Author",
        },
        {
          value: "book_library",
          label: "Library",
        },
        {
          value: "book_location",
          label: "Location",
        },
        {
          value: "book_status",
          label: "Status",
        },
        {
          value: "book_description",
          label: "Description",
        },
      ],
      queryInfo: {
        pageNum: 1,
        pageSize: 5,
        condition: "",
        query: "",
      },
      total: 0,
      types: [
        {
          typeId: "Fairy Tale",
          typeName: "Fairy Tale",
        },
        {
          typeId: "Literature",
          typeName: "Literature",
        },
        {
          typeId: "Essay",
          typeName: "Essay",
        },
      ],
      title: "Book Management",
      json_fields: {
        "Book ID": "bookNumber",
        "Title": "bookName",
        "Author": "bookAuthor",
        "Library": "bookLibrary",
        "Category": "bookType",
        "Location": "bookLocation",
        "Status": "bookStatus",
        "Description": "bookDescription",
      },
      loading: true,
      multipleSelection: [],
      fileList: []
    };
  },
  methods: {
    handleSizeChange(val) {
      this.queryInfo.pageSize = val;
      this.getBookList();
    },
    handleCurrentChange(val) {
      this.queryInfo.pageNum = val;
      this.getBookList();
    },
    handleSelectionChange(val) {
      this.multipleSelection = val;
    },
    // Show edit dialog and populate data from database
    async showEditDialog(id) {
      // Get book categories from database
      const { data: res1 } = await this.$http.get("admin/get_type");
      if (res1.status !== 200) {
        return this.$message.error(res1.msg);
      }
      this.types = res1.data;
      this.editDialogVisible = true;
      const { data: res } = await this.$http.get(
        "admin/get_bookinformation/" + id
      );
      if (res.status !== 200) {
        return this.$message.error(res.msg);
      }
      this.editForm = res.data;
    },
    // Reset form when edit dialog is closed
    editDialogClosed() {
      this.$refs.editFormRef.resetFields();
    },
    // Delete single book
    async removeUserById(id) {
      // Confirm deletion with user
      const confirmResult = await this.$confirm(
        "This will permanently delete this book. Continue?",
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
      const { data: res } = await this.$http.get("admin/delete_book/" + id);
      if (res.status !== 200) {
        return this.$message.error(res.msg);
      }
      this.$message.success(res.msg);
      // Reset pagination and refresh list
      this.queryInfo.pageNum = 1;
      this.queryInfo.pageSize = 5;
      this.getBookList();
    },
    // Reset form when add dialog is closed
    addDialogClosed() {
      this.$refs.addFormRef.resetFields();
    },
    // Show add dialog and load categories
    async showAddDialog() {
      const { data: res } = await this.$http.get("admin/get_type");
      console.log(res);
      if (res.status !== 200) {
        return this.$message.error(res.msg);
      }
      this.types = res.data;
      this.addDialogVisible = true;
    },
    async getBookList() {
      this.loading = true;
      const { data: res } = await this.$http.post(
        "admin/get_booklist",
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
    async addBook() {
      const { data: res } = await this.$http.post(
        "admin/add_book",
        this.addForm
      );
      if (res.status !== 200) {
        return this.$message.error(res.msg);
      }
      this.$message.success(res.msg);
      this.getBookList();
      this.addDialogVisible = false;
    },
    async updateBook() {
      this.$refs.editFormRef.validate(async (valid) => {
        if (!valid) {
          return;
        }
        const { data: res } = await this.$http.post(
          "admin/update_book",
          this.editForm
        );
        if (res.status !== 200) {
          return this.$message.error(res.msg);
        }
        this.$message.success(res.msg);
        this.getBookList();
        this.editDialogVisible = false;
      });
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
    },
    // Batch delete books
    async removeBatch() {
      const confirmResult = await this.$confirm(
        "This will permanently delete these books. Continue?",
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
      if (this.multipleSelection.length == 0) {
        return this.$message.error({
          message: "No items selected for batch deletion",
          duration: 1000
        });
      }
      const { data: res } = await this.$http.delete("admin/delete_book_batch", {
        data: this.multipleSelection
      });
      if (res.status !== 200) {
        return this.$message.error({
          message: res.msg,
          duration: 1000
        });
      }
      this.$message.success({
        message: res.msg,
        duration: 1000
      });
      this.queryInfo.pageNum = 1;
      this.queryInfo.pageSize = 5;
      this.getBookList();
    },
    submitUpload() {
      console.log(this.$refs.upload.data);
      this.$refs.upload.submit();
      this.$message.success({
        duration: 1500,
        message: "Books imported successfully from Excel"
      })
    },
    handleRemove(file, fileList) {
      console.log(file, fileList);
    },
    handlePreview(file) {
      console.log(file);
    },
    onSuccess(response, file, fileList) {
      // console.log(response);
      // console.log(file);
      // console.log(fileList);
    }

  },
  created() {
    this.getBookList();
  },
  computed: {
    headers() {
      return {
        "Authorization": "Bearer " + window.sessionStorage.getItem('token')
      };
    }
  }
};
</script>

<style></style>