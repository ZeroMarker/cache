webpackJsonp([289],{"Q+Eh":function(e,t){},r7mG:function(e,t,i){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var n=i("Dd8w"),s=i.n(n),r=i("NYxO"),a=i("XlQt"),l=i("W5Fe"),o={components:{hgbutton:a.default,hgpagination:l.default},computed:s()({},Object(r.b)(["Height","styleCode"])),data:function(){return{elementlist:[],currentPage:1,currentPageSize:20,totalCount:0,dialogVisible:!1,finds:{input:"",findWard:""},tableData:[],roleStore:[],editForm:{UserID:"",UserName:"",SSUserCode:"",StartDate:(new Date).addDate(-1),EndDate:"",UserRole:[],rw:""},rules:{UserID:[{required:!0,message:"请输入工号！",trigger:"blur"}],UserName:[{required:!0,message:"请输入姓名！",trigger:"change"}],StartDate:[{required:!0,message:"请选择启用日期！",trigger:"change"}]},winFlag:0}},created:function(){this.LoadRoleStore(),this.FindClick();var e=this.$router.currentRoute.path.slice(1,this.$router.currentRoute.path.length);this.loadElementsForRouter("elementlist",e)},methods:{LoadRoleStore:function(){var e=this,t=this.axiosConfig("web.INMSetComm","FindRoleList","RecQuery","parr$");e.$ajax.request(t).then(function(t){e.roleStore=t.data.rows}).catch(function(e){})},HandleCurrentChange:function(e){this.currentPage=e.currentPage,this.FindClick()},HandleSizeChange:function(e){this.currentPageSize=e,this.FindClick()},RowDblclick:function(e){var t=this;if(t.winFlag=1,""!=e.rw){var i=this.axiosConfig("web.INMDBComm","GetUser","RecMethod","rw$"+e.rw);this.$ajax.request(i).then(function(e){t.dialogVisible=!0,t.$nextTick(function(){t.$refs.editForm.resetFields(),t.setForm(t.$refs.editForm,t.editForm,e.data)})}).catch(function(e){})}},FindClick:function(){var e=this,t=e.finds.input,i=t=t||"",n=(this.currentPage-1)*this.currentPageSize,s=this.currentPageSize,r=this.axiosConfig("web.INMDBComm","FindUserList","RecQuery","parr$"+i,"start$"+n,"limit$"+s);this.$ajax.request(r).then(function(t){e.tableData=t.data.rows,e.totalCount=parseInt(t.data.results)}).catch(function(e){})},AddClick:function(){var e=this;e.winFlag=0,e.dialogVisible=!0,e.$nextTick(function(){e.$refs.editForm.resetFields(),e.editForm.rw=""})},SaveClick:function(){var e=this;this.$refs.editForm.validate(function(t){if(!t)return!1;var i="";for(var n in e.editForm)void 0==e.editForm[n]&&(e.editForm[n]=""),i=e.editForm[n]instanceof Date?i+n+"|"+e.editForm[n].Format("yyyy-MM-dd")+"^":i+n+"|"+e.editForm[n].toString()+"^";if(""!=i){var s=e.axiosConfig("web.INMDBComm","SaveUser","Method","parr$"+i);e.$ajax.request(s).then(function(t){1==t.data?(e.$message({message:"保存成功！",type:"success",showClose:!0,customClass:"success_class"}),e.dialogVisible=!1,e.FindClick()):t.data.length<100?e.$message({type:"warning",message:t.data,showClose:!0,customClass:"warning_class"}):e.$message({type:"warning",message:"后台方法错了^_^",showClose:!0,customClass:"warning_class"})}).catch(function(t){e.$message({type:"warning",message:"保存失败！",showClose:!0,customClass:"warning_class"})})}})}}},c={render:function(){var e=this,t=e.$createElement,i=e._self._c||t;return i("div",{staticClass:"userset-panel"},[i("div",{staticClass:"top-tool-inputDiv"},[i("el-form",{ref:"finds",attrs:{model:e.finds,inline:!0},nativeOn:{submit:function(e){e.preventDefault()}}},[i("el-form-item",[i("el-input",{staticStyle:{width:"140px"},attrs:{size:"mini",placeholder:e.$t("menu.UserSet.5ncy64xskdc0")},nativeOn:{keyup:function(t){return!t.type.indexOf("key")&&e._k(t.keyCode,"enter",13,t.key,"Enter")?null:e.FindClick(t)}},model:{value:e.finds.input,callback:function(t){e.$set(e.finds,"input",t)},expression:"finds.input"}})],1),e._v(" "),i("el-form-item",[e.elementlist.findClick?i("hgbutton",{attrs:{type:"default",styleCode:e.styleCode,icon:"nm-icon-w-find"},on:{click:e.FindClick}},[e._v(e._s(e.$t("menu.UserSet.5nrnb02eydg0")))]):e._e()],1)],1)],1),e._v(" "),i("div",{staticClass:"top-tool-button"},[e.elementlist.addClick?i("hgbutton",{attrs:{type:"text",issvg:e.styleCode,icon:e.styleCode?"#nm-icon-add":"nm-icon-lite-add"},on:{click:e.AddClick}},[e._v(e._s(e.$t("menu.UserSet.5nrnb02ezf40")))]):e._e(),e._v(" "),e.elementlist.LinkClick?i("hgbutton",{attrs:{type:"text",issvg:e.styleCode,icon:e.styleCode?"#nm-icon-link":"nm-icon-lite-person"}},[e._v(e._s(e.$t("menu.UserSet.5ncy64xsnuc0")))]):e._e()],1),e._v(" "),i("div",{staticClass:"top-tool-table"},[i("el-table",{attrs:{data:e.tableData,height:e.styleCode?e.Height-130:e.Height-124,border:e.styleCode,"header-cell-style":e.headerCellFontWeight,"highlight-current-row":"","show-overflow-tooltip":"",align:"left"},on:{"row-dblclick":e.RowDblclick}},[i("el-table-column",{attrs:{type:"index",label:"",width:"40",align:"center"}}),e._v(" "),i("el-table-column",{attrs:{prop:"UserID",label:e.$t("menu.UserSet.5nrnb02h2p40"),width:"",align:"left"}}),e._v(" "),i("el-table-column",{attrs:{prop:"UserName",label:e.$t("menu.UserSet.5nrnb02i5es0"),width:"",align:"left"}}),e._v(" "),i("el-table-column",{attrs:{prop:"UserRoleDesc",label:e.$t("menu.UserSet.5ncy64xsqb00"),"show-overflow-tooltip":"",width:"",align:"left"}}),e._v(" "),i("el-table-column",{attrs:{prop:"SSUserCode",label:e.$t("menu.UserSet.5ncy64xsqp40"),width:"",align:"left"}}),e._v(" "),i("el-table-column",{attrs:{prop:"SSUerName",label:e.$t("menu.UserSet.5ncy64xsr1s0"),width:"",align:"left"}}),e._v(" "),i("el-table-column",{attrs:{prop:"PerName",label:e.$t("menu.UserSet.5ncy64xsre40"),width:"",align:"left"}}),e._v(" "),i("el-table-column",{attrs:{prop:"PerWardDesc",label:e.$t("menu.UserSet.5nrnb02k1ys0"),"show-overflow-tooltip":"",width:"",align:"left"}}),e._v(" "),i("el-table-column",{attrs:{prop:"StartDate",label:e.$t("menu.UserSet.5nrnb02lo1s0"),width:"",align:"left",formatter:e.PTableDateHisShow}}),e._v(" "),i("el-table-column",{attrs:{prop:"EndDate",label:e.$t("menu.UserSet.5nrnb02n7pc0"),width:"",align:"left",formatter:e.PTableDateHisShow}}),e._v(" "),e._e()],1),e._v(" "),i("hgpagination",{attrs:{styleCode:e.styleCode,sizes:[20,40,50,100],totalCount:e.totalCount,pageNumber:e.currentPage,pageSize:e.currentPageSize},on:{changePage:e.HandleCurrentChange,getPageSize:e.HandleSizeChange}})],1),e._v(" "),i("div",[i("el-dialog",{attrs:{title:0==e.winFlag?e.$t("menu.UserSet.5nrnb02ezf40"):e.$t("menu.UserSet.5nrnb02ezf41"),visible:e.dialogVisible,"close-on-click-modal":!1,width:"424px"},on:{"update:visible":function(t){e.dialogVisible=t}}},[i("div",{staticClass:"dialog-header-title",attrs:{slot:"title"},slot:"title"},[e.styleCode?i("i",{class:[0==e.winFlag?"nm-icon-w-plus":"nm-icon-w-edit"]}):e._e(),e._v(" "),0==e.winFlag?i("span",[e._v(e._s(e.$t("menu.UserSet.5nrnb02ezf40")))]):1==e.winFlag?i("span",[e._v(e._s(e.$t("menu.UserSet.5nrnb02ezf41")))]):e._e()]),e._v(" "),i("el-form",{ref:"editForm",attrs:{model:e.editForm,rules:e.rules,"label-width":"120px",inline:!0,"label-position":"right",align:"left"}},[i("el-form-item",{attrs:{label:e.$t("menu.UserSet.5nrnb02h2p40"),prop:"UserID"}},[i("el-input",{staticStyle:{width:"240px"},attrs:{size:"mini"},model:{value:e.editForm.UserID,callback:function(t){e.$set(e.editForm,"UserID",t)},expression:"editForm.UserID"}})],1),e._v(" "),i("el-form-item",{attrs:{label:e.$t("menu.UserSet.5nrnb02rthc0"),prop:"UserName"}},[i("el-input",{staticStyle:{width:"240px"},attrs:{size:"mini"},model:{value:e.editForm.UserName,callback:function(t){e.$set(e.editForm,"UserName",t)},expression:"editForm.UserName"}})],1),e._v(" "),i("el-form-item",{attrs:{label:e.$t("menu.UserSet.5ncy64xsqp40"),prop:"SSUserCode"}},[i("el-input",{staticStyle:{width:"240px"},attrs:{size:"mini"},model:{value:e.editForm.SSUserCode,callback:function(t){e.$set(e.editForm,"SSUserCode",t)},expression:"editForm.SSUserCode"}})],1),e._v(" "),i("el-form-item",{attrs:{label:e.$t("menu.UserSet.5nrnb02sv5g0"),prop:"UserRole"}},[i("el-select",{staticStyle:{width:"240px"},attrs:{multiple:"",placeholder:e.$t("menu.UserSet.5ncy64xsyuk0"),size:"mini"},model:{value:e.editForm.UserRole,callback:function(t){e.$set(e.editForm,"UserRole",t)},expression:"editForm.UserRole"}},e._l(e.roleStore,function(e){return i("el-option",{key:e.rw,attrs:{label:e.RoleDesc,value:e.rw}})}),1)],1),e._v(" "),i("el-form-item",{attrs:{label:e.$t("menu.UserSet.5nrnb02lo1s0"),prop:"StartDate"}},[i("el-date-picker",{staticStyle:{width:"240px"},attrs:{type:"date",format:this.$store.state.mainframe.DateFormat,size:"mini"},model:{value:e.editForm.StartDate,callback:function(t){e.$set(e.editForm,"StartDate",t)},expression:"editForm.StartDate"}})],1),e._v(" "),i("el-form-item",{attrs:{label:e.$t("menu.UserSet.5nrnb02n7pc0"),prop:"EndDate"}},[i("el-date-picker",{staticStyle:{width:"240px"},attrs:{type:"date",format:this.$store.state.mainframe.DateFormat,size:"mini"},model:{value:e.editForm.EndDate,callback:function(t){e.$set(e.editForm,"EndDate",t)},expression:"editForm.EndDate"}})],1)],1),e._v(" "),i("div",{staticClass:"bottom-button"},[e.elementlist.saveClick?i("hgbutton",{directives:[{name:"intervalclick",rawName:"v-intervalclick",value:{func:e.SaveClick,time:500},expression:"{func:SaveClick,time:500}"}],attrs:{type:e.styleCode?"default":"success",styleCode:e.styleCode}},[e._v(e._s(e.$t("menu.UserSet.5nrnb02x3vo0")))]):e._e(),e._v(" "),i("hgbutton",{attrs:{type:"default",styleCode:e.styleCode},on:{click:function(t){e.dialogVisible=!1}}},[e._v(e._s(e.$t("menu.UserSet.5nrnb02x4ss0")))])],1)],1)],1)])},staticRenderFns:[]};var d=i("VU/8")(o,c,!1,function(e){i("Q+Eh")},null,null);t.default=d.exports}});