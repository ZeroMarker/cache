webpackJsonp([182],{PuXY:function(e,t){},vKGq:function(e,t,a){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var s=a("Dd8w"),r=a.n(s),n=a("NYxO"),i=a("XlQt"),o=a("W5Fe"),l={components:{hgbutton:i.default,hgpagination:o.default},name:"WishArrange",computed:r()({},Object(n.b)(["Height","styleCode"])),data:function(){return{labelWidth:"width:180px",tableData:[],tableDataAll:[],currentPage:1,pageSize:20,totalCount:0,finds:{wardDR:"",stDate:new Date((new Date).setDate(1)),endDate:(new Date).getMonthDate((new Date).getMonthDay())},editForm:{PerDR:"",WardDR:"",WishDate:"",PostDR:"",Status:"",Remark:"",rw:""},rules:{WishDate:[{required:!0,message:"请选择排班日期",type:"date",trigger:"change"}],WardDR:[{required:!0,message:"请选择病区",trigger:"change"}],PostDR:[{required:!0,message:"请选择班次",trigger:"change"}]},dialogVisible:!1,WardStorage:[],WardPostData:[],selRow:"",disableFlag:!1,winFlag:0}},watch:{"editForm.WardDR":{handler:function(){this.loadWardPostData()}}},created:function(){this.LoadRoleWard()},methods:{LoadRoleWard:function(){var e=this,t=this.axiosConfig("web.INMDataLimit","FindRoleWardList","RecQuery","nurseid$"+sessionStorage.loginID);this.$ajax.request(t).then(function(t){t.data instanceof Object?e.WardStorage=t.data.rows:e.$message({type:"error",message:"获取权限病区失败",showClose:!0,customClass:"error_class"})}).catch(function(t){e.$message({type:"error",message:"获取权限病区失败",showClose:!0,customClass:"error_class"})})},loadTableData:function(){var e=this;e.selRow="";var t=e.finds.stDate,a=e.finds.endDate;t=t||"",a=a||"",t=t instanceof Date?t.Format("yyyy-MM-dd"):"",a=a instanceof Date?a.Format("yyyy-MM-dd"):"";var s=sessionStorage.getItem("loginPerID")+"^"+t+"^"+a,r=(e.currentPage-1)*e.pageSize,n=e.pageSize,i=e.axiosConfig("web.INMArgComm","FindWishArrangeList","RecQuery","parr$"+s);e.$ajax.request(i).then(function(t){e.tableData=t.data.rows.slice(r,r+n),e.tableDataAll=t.data.rows,e.totalCount=parseInt(t.data.results)}).catch(function(e){})},rowClick:function(e){this.selRow=e},rowDBClick:function(e){this.selRow=e,this.winFlag=1,this.editClick()},addClick:function(){var e=this;e.winFlag=0,e.dialogVisible=!0,e.$nextTick(function(){e.$refs.editForm.resetFields(),e.editForm.rw="",e.disableFlag=!1,e.editForm.PerDR=sessionStorage.getItem("loginPerID")})},editClick:function(){var e=this;if(e.selRow&&e.selRow.rw){var t=e.axiosConfig("web.INMArgComm","getWishArrange","RecMethod","id$"+e.selRow.rw);e.$ajax.request(t).then(function(t){e.dialogVisible=!0,e.$nextTick(function(){e.setForm(e.$refs.editForm,e.editForm,t.data),"N"!=e.editForm.Status?e.disableFlag=!0:e.disableFlag=!1})}).catch(function(e){})}else e.$message({type:"warning",message:"请选择记录",showClose:!0,customClass:"warning_class"})},saveClick:function(e){var t=this;t.editForm.Status=e,this.$refs.editForm.validate(function(e){if(!e)return!1;var a="";for(var s in t.editForm)void 0!=s&&(void 0==t.editForm[s]&&(t.editForm[s]=""),a=t.editForm[s]instanceof Date?a+s+"|"+t.editForm[s].Format("yyyy-MM-dd")+"^":a+s+"|"+t.editForm[s].toString()+"^");if(""!=a){var r=t.axiosConfig("web.INMArgComm","SaveWishArrange","Method","parr$"+a);t.$ajax.request(r).then(function(e){1==e.data?(t.$message({message:"保存成功！",type:"success",showClose:!0,customClass:"success_class"}),t.dialogVisible=!1,t.loadTableData()):0==e.data?t.$message({message:"保存失败！",type:"error",showClose:!0,customClass:"error_class"}):t.$message({message:e.data,type:"error",showClose:!0,customClass:"error_class"})}).catch(function(e){t.$message({message:"保存失败！",type:"error",showClose:!0,customClass:"error_class"})})}})},delClick:function(){var e=this;e.selRow.rw?e.selRow.PerDR==sessionStorage.getItem("loginPerID")?e.$ajax.request(e.axiosConfig("web.INMArgComm","getWishArgStatus","Method","id$"+e.selRow.rw)).then(function(t){if(t){if("A"==t.data)return void e.$message({type:"warning",message:"已审核，不允许删除",showClose:!0,customClass:"warning_class"});if("S"==t.data)return void e.$message({type:"warning",message:"已提交，不允许删除",showClose:!0,customClass:"warning_class"});"N"!=t.data&&"B"!=t.data||e.$confirm("此操作将永久删除该记录, 是否继续?","提示",{confirmButtonText:"确定",cancelButtonText:"取消",type:"warning"}).then(function(){e.$ajax.request(e.axiosConfig("web.INMArgComm","DeleteWishRec","Method","id$"+e.selRow.rw)).then(function(t){1==t.data?(e.$message({type:"success",message:"删除成功",showClose:!0,customClass:"success_class"}),e.loadTableData()):e.$message({type:"warning",message:"删除失败",showClose:!0,customClass:"warning_class"})})}).catch(function(){e.$message({type:"info",message:"已取消删除",showClose:!0,customClass:"info_class"})})}}):e.$message({type:"warning",message:"只能删除本人的记录",showClose:!0,customClass:"warning_class"}):e.$message({type:"warning",message:"请选择要删除的记录！",showClose:!0,customClass:"warning_class"})},loadWardPostData:function(){var e=this;if(e.WardPostData=new Array,void 0!=this.editForm.WardDR&&""!=this.editForm.WardDR){var t="^"+this.editForm.WardDR+"^P",a=e.axiosConfig("web.INMDBComm","FindWardWishPostList","RecQuery","parr$"+t);e.$ajax.request(a).then(function(t){e.WardPostData=t.data.rows}).catch(function(e){})}},handleCurrentChange:function(e){this.currentPage=e.currentPage,this.loadTableData()},handleSizeChange:function(e){this.pageSize=e,this.loadTableData()}}},d={render:function(){var e=this,t=e.$createElement,a=e._self._c||t;return a("div",{staticClass:"wisharrange-panel"},[a("div",{staticClass:"top-tool-inputDiv"},[a("el-form",{ref:"form1",attrs:{model:e.finds,inline:!0},nativeOn:{submit:function(e){e.preventDefault()}}},[a("el-form-item",{staticClass:"tool-item",attrs:{label:e.$t("menu.WishArrange.5nrnavogv8s0"),prop:"stDate"}},[a("el-date-picker",{staticStyle:{width:"120px"},attrs:{type:"date",format:this.$store.state.mainframe.DateFormat,clearable:"",placeholder:e.$t("menu.WishArrange.5nrnavogv8s0"),size:"mini"},model:{value:e.finds.stDate,callback:function(t){e.$set(e.finds,"stDate",t)},expression:"finds.stDate"}})],1),e._v(" "),a("el-form-item",{staticClass:"tool-item",attrs:{label:e.$t("menu.WishArrange.5ncy637n75s0"),prop:"endDate"}},[a("el-date-picker",{staticStyle:{width:"120px"},attrs:{type:"date",format:this.$store.state.mainframe.DateFormat,placeholder:e.$t("menu.WishArrange.5nrnavojp000"),size:"mini"},model:{value:e.finds.endDate,callback:function(t){e.$set(e.finds,"endDate",t)},expression:"finds.endDate"}})],1),e._v(" "),a("el-form-item",[a("hgbutton",{attrs:{type:"default",styleCode:e.styleCode,icon:"nm-icon-w-find"},on:{click:e.loadTableData}},[e._v(e._s(e.$t("menu.WishArrange.5nrnavojqf40")))])],1)],1)],1),e._v(" "),a("div",{staticClass:"top-tool-button"},[a("hgbutton",{attrs:{type:"text",issvg:e.styleCode,icon:e.styleCode?"#nm-icon-add":"nm-icon-lite-add"},on:{click:e.addClick}},[e._v(e._s(e.$t("menu.WishArrange.5nrnavokk5o0")))]),e._v(" "),a("hgbutton",{attrs:{type:"text",issvg:e.styleCode,icon:e.styleCode?"#nm-icon-cancel":"nm-icon-lite-cancel"},on:{click:e.delClick}},[e._v(e._s(e.$t("menu.WishArrange.5nrnavoklv80")))]),e._v(" "),a("hgbutton",{attrs:{type:"text",issvg:e.styleCode,icon:e.styleCode?"#nm-icon-export":"nm-icon-lite-export"},on:{click:function(t){e.exportData("tableData",e.tableDataAll,e.$t("menu.WishArrange.5ncy637od740"))}}},[e._v(e._s(e.$t("menu.WishArrange.5nrnavokpa40")))])],1),e._v(" "),a("div",{staticClass:"top-tool-table"},[a("el-table",{ref:"tableData",attrs:{data:e.tableData,"header-cell-style":e.headerCellFontWeight,height:e.styleCode?e.Height-130:e.Height-124,border:e.styleCode,"highlight-current-row":"",align:"left",label:e.$t("menu.WishArrange.5nrnavosddk0")},on:{"row-dblclick":e.rowDBClick,"row-click":e.rowClick}},[a("el-table-column",{attrs:{type:"index",align:"center",width:"40"}}),e._v(" "),a("el-table-column",{attrs:{label:e.$t("menu.WishArrange.5ncy637qvv40"),prop:"PerName"}}),e._v(" "),a("el-table-column",{attrs:{label:e.$t("menu.WishArrange.5nrnavoz53g0"),prop:"WardDesc"}}),e._v(" "),a("el-table-column",{attrs:{label:e.$t("menu.WishArrange.5nrnavp1p8g0"),prop:"WishDate",formatter:e.PTableDateHisShow}}),e._v(" "),a("el-table-column",{attrs:{label:e.$t("menu.WishArrange.5nrnavp3m7w0"),prop:"PostDesc"}}),e._v(" "),a("el-table-column",{attrs:{label:e.$t("menu.WishArrange.5nrnavp5fqw0"),prop:"StatusDesc"}}),e._v(" "),a("el-table-column",{attrs:{label:e.$t("menu.WishArrange.5nrnavp7e5w0"),prop:"Remark"}}),e._v(" "),a("el-table-column",{attrs:{label:e.$t("menu.WishArrange.5nrnavp9b3s0"),prop:"AuditorName"}}),e._v(" "),a("el-table-column",{attrs:{label:e.$t("menu.WishArrange.5nrnavpb8og0"),prop:"AuditDate",formatter:e.PTableDateHisShow}}),e._v(" "),e._e(),e._v(" "),e._e(),e._v(" "),e._e(),e._v(" "),e._e(),e._v(" "),e._e()],1),e._v(" "),a("hgpagination",{attrs:{styleCode:e.styleCode,sizes:[20,40,50,100],totalCount:e.totalCount,pageNumber:e.currentPage,pageSize:e.pageSize},on:{changePage:e.handleCurrentChange,getPageSize:e.handleSizeChange}})],1),e._v(" "),a("div",[a("el-dialog",{attrs:{title:0==e.winFlag?e.$t("menu.WishArrange.5nrnavokk5o0"):e.$t("menu.WishArrange.5nrnavokk5o1"),visible:e.dialogVisible,"close-on-click-modal":!1,width:"350px",align:"center"},on:{"update:visible":function(t){e.dialogVisible=t}}},[a("div",{staticClass:"dialog-header-title",attrs:{slot:"title"},slot:"title"},[e.styleCode?a("i",{class:[0==e.winFlag?"nm-icon-w-plus":"nm-icon-w-edit"]}):e._e(),e._v(" "),0==e.winFlag?a("span",[e._v(e._s(e.$t("menu.WishArrange.5nrnavokk5o0")))]):1==e.winFlag?a("span",[e._v(e._s(e.$t("menu.WishArrange.5nrnavokk5o1")))]):e._e()]),e._v(" "),a("el-form",{ref:"editForm",attrs:{model:e.editForm,rules:e.rules,"label-width":"113px","label-position":"right"}},[a("el-form-item",{attrs:{label:e.$t("menu.WishArrange.5nrnavpgftc0"),prop:"WishDate"}},[a("el-date-picker",{style:e.labelWidth,attrs:{type:"date",format:this.$store.state.mainframe.DateFormat,disabled:e.disableFlag,clearable:"",placeholder:e.$t("menu.WishArrange.5nrnavpgftc0"),size:"mini"},model:{value:e.editForm.WishDate,callback:function(t){e.$set(e.editForm,"WishDate",t)},expression:"editForm.WishDate"}})],1),e._v(" "),a("el-form-item",{attrs:{label:e.$t("menu.WishArrange.5nrnavoz53g0"),prop:"WardDR"}},[a("el-select",{style:e.labelWidth,attrs:{disabled:e.disableFlag,size:"mini",filterable:"",clearable:""},model:{value:e.editForm.WardDR,callback:function(t){e.$set(e.editForm,"WardDR",t)},expression:"editForm.WardDR"}},e._l(e.WardStorage,function(e){return a("el-option",{key:e.rw,attrs:{label:e.WardDesc,value:e.rw}})}),1)],1),e._v(" "),a("el-form-item",{attrs:{label:e.$t("menu.WishArrange.5nrnavp3m7w0"),prop:"PostDR"}},[a("el-select",{style:e.labelWidth,attrs:{disabled:e.disableFlag,size:"mini","no-data-text":e.editForm.WardDR?e.$t("menu.WishArrange.5nrnavppy1k0"):e.$t("menu.WishArrange.5nrnavpow2w0"),filterable:"",clearable:""},model:{value:e.editForm.PostDR,callback:function(t){e.$set(e.editForm,"PostDR",t)},expression:"editForm.PostDR"}},e._l(e.WardPostData,function(e){return a("el-option",{key:e.rw,attrs:{label:e.PostDesc,value:e.rw}})}),1)],1),e._v(" "),a("el-form-item",{attrs:{label:e.$t("menu.WishArrange.5nrnavp7e5w0"),prop:"Remark"}},[a("el-input",{style:e.labelWidth,attrs:{disabled:e.disableFlag,placeholder:e.$t("menu.WishArrange.5nrnavpy0xs0"),size:"mini"},model:{value:e.editForm.Remark,callback:function(t){e.$set(e.editForm,"Remark",t)},expression:"editForm.Remark"}})],1)],1),e._v(" "),e.disableFlag?e._e():a("div",{staticClass:"bottom-button"},[a("hgbutton",{directives:[{name:"intervalclick",rawName:"v-intervalclick",value:{func:e.saveClick,time:500,value1:"N"},expression:"{func:saveClick,time:500,value1:'N'}"}],attrs:{type:e.styleCode?"default":"success",styleCode:e.styleCode}},[e._v(e._s(e.$t("menu.WishArrange.5nrnavpy3c00")))]),e._v(" "),a("hgbutton",{directives:[{name:"intervalclick",rawName:"v-intervalclick",value:{func:e.saveClick,time:500,value1:"S"},expression:"{func:saveClick,time:500,value1:'S'}"}],staticStyle:{width:"100px"},attrs:{type:"default",styleCode:e.styleCode}},[e._v(e._s(e.$t("menu.WishArrange.5nrnavpy4ss0")))]),e._v(" "),a("hgbutton",{attrs:{type:"default",styleCode:e.styleCode},on:{click:function(t){e.dialogVisible=!1}}},[e._v(e._s(e.$t("menu.WishArrange.5nrnavpy5hc0")))])],1)],1)],1)])},staticRenderFns:[]};var c=a("VU/8")(l,d,!1,function(e){a("PuXY")},null,null);t.default=c.exports}});