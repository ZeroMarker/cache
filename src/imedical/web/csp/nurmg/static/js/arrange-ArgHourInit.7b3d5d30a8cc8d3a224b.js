webpackJsonp([236],{"6CZq":function(e,t,o){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var r=o("Dd8w"),s=o.n(r),a=o("NYxO"),i=o("XlQt"),n=o("W5Fe"),l={components:{hgbutton:i.default,hgpagination:n.default},name:"ArgHourInit",computed:s()({},Object(a.b)(["Height","styleCode"])),data:function(){var e=this;return{elementlist:{},ToolForm:{Name:""},WardNurseStore:[],TableData:[],CurrentPage:1,PageSize:20,TotalCount:0,RecForm:{Per:"",StDate:"",Hour:0,rw:""},Rules:{Per:[{required:!0,message:"请选择姓名",trigger:"change"}],StDate:[{required:!0,message:"请选择检查日期",trigger:"change",type:"date"}],Hour:[{required:!0,message:"请填写积假数",trigger:"blur"}]},SelectRow:{},DialogVisible:!1,SaveLoading:!1,SysArgType:"Week",PickerOptions:{disabledDate:function(t){return"Week"==e.SysArgType?1!=t.getDay():1!=t.getDate()}},winFlag:0}},methods:{GetArgParam:function(){var e=this,t=e.axiosConfig("web.INMSetComm","GetArgParam","RecMethod","id$1");e.$ajax.request(t).then(function(t){t.data instanceof Object?"Month"==t.data.ArgPeriod?e.SysArgType="Month":e.SysArgType="Week":e.$message({type:"error",message:"获取排班参数失败",showClose:!0,customClass:"error_class"})}).catch(function(t){e.$message({type:"error",message:"获取排班参数失败",showClose:!0,customClass:"error_class"})})},LoadRoleNurse:function(){var e=this;this.WardNurseStore=[];var t=this.axiosConfig("web.INMDataLimit","FindRoleNurseList","RecQuery","nurseid$"+sessionStorage.loginID);this.$ajax.request(t).then(function(t){t.data instanceof Object?e.WardNurseStore=t.data.rows:e.$message({type:"error",message:"获取权限护士失败",showClose:!0,customClass:"error_class"})}).catch(function(t){e.$message({type:"error",message:"获取权限护士失败",showClose:!0,customClass:"error_class"})})},ToolFormSearch:function(){var e=this,t=(this.CurrentPage-1)*this.PageSize,o=this.PageSize,r=this.ToolForm.Name;this.TableData=[];var s=this.axiosConfig("web.INMArgComm","FindHourList","RecQuery","parr$"+r,"nurseid$"+sessionStorage.loginID,"start$"+t,"limit$"+o);this.$ajax.request(s).then(function(t){t.data instanceof Object?(e.TableData=t.data.rows,e.TotalCount=parseInt(t.data.results)):e.$message({type:"error",message:"获取数据失败",showClose:!0,customClass:"error_class"}),e.SelectRow=""}).catch(function(t){e.$message({type:"error",message:"获取数据失败",showClose:!0,customClass:"error_class"})})},AddClick:function(){var e=this;this.DialogVisible=!0,this.winFlag=0,this.$nextTick(function(){e.$refs.RecForm.resetFields(),e.RecForm.rw=""})},SaveHour:function(){var e=this;this.$refs.RecForm.validate(function(t){if(t){var o=e.RecForm.Per,r="";e.RecForm.StDate instanceof Date&&(r=e.RecForm.StDate.Format("YYYY-MM-dd"));var s=o+"^"+r+"^"+e.RecForm.Hour+"^"+e.RecForm.rw;e.SaveLoading=!0;var a=e.axiosConfig("web.INMArgComm","SaveArgHour","Method","parr$"+s,"nurseid$"+sessionStorage.loginID);e.$ajax.request(a).then(function(t){e.SaveLoading=!1,1==t.data?(e.DialogVisible=!1,e.$message({type:"success",message:"保存成功",showClose:!0,customClass:"success_class"}),e.ToolFormSearch()):t.data.length<100?e.$message({type:"error",message:t.data,showClose:!0,customClass:"error_class"}):e.$message({type:"error",message:"保存失败,请联系开发",showClose:!0,customClass:"error_class"})}).catch(function(t){e.SaveLoading=!1,e.$message({type:"error",message:"保存失败,请联系开发",showClose:!0,customClass:"error_class"})})}})},LoadRecForm:function(){var e=this;this.SaveLoading=!0;var t=this.axiosConfig("web.INMArgComm","GetArgHour","RecMethod","id$"+this.SelectRow.rw);this.$ajax.request(t).then(function(t){if(e.SaveLoading=!1,t.data instanceof Object){e.RecForm.Per=t.data.ArgPer,e.RecForm.StDate=t.data.ArgDate?new Date(t.data.ArgDate):"";var o=parseFloat(t.data.ArgHour);e.RecForm.Hour=isNaN(o)?0:o,e.RecForm.rw=t.data.rw}else e.DialogVisible=!1,e.$message({type:"error",message:"获取数据内容失败",showClose:!0,customClass:"error_class"})}).catch(function(t){e.SaveLoading=!1,e.DialogVisible=!1,e.$message({type:"error",message:"获取数据内容失败",showClose:!0,customClass:"error_class"})})},DeleteClick:function(){var e=this;this.SelectRow&&this.SelectRow.rw?this.$confirm("此操作将删除该记录, 是否继续?","提示",{confirmButtonText:"确定",cancelButtonText:"关闭",closeOnClickModal:!1,type:"warning"}).then(function(){var t=e.axiosConfig("web.INMArgComm","DeleteArgHour","Method","id$"+e.SelectRow.rw);e.$ajax.request(t).then(function(t){1==t.data?(e.$message({message:"删除成功",type:"success",showClose:!0,customClass:"success_class"}),e.ToolFormSearch()):e.$message({message:"删除失败",type:"error",showClose:!0,customClass:"error_class"})}).catch(function(t){e.$message({message:"删除失败",type:"error",showClose:!0,customClass:"error_class"})})}).catch(function(){e.$message({type:"info",message:"取消删除",showClose:!0,customClass:"info_class"})}):this.$message({type:"warning",message:"请先选中一行数据",showClose:!0,customClass:"warning_class"})},RowClick:function(e){this.SelectRow=e},RowDblClick:function(e){var t=this;this.SelectRow=e,this.winFlag=1,this.DialogVisible=!0,this.$nextTick(function(){t.$refs.RecForm.resetFields(),t.RecForm.rw="",t.LoadRecForm()})},HandleSizeChange:function(e){this.PageSize=e,this.ToolFormSearch()},HandleCurrentChange:function(e){this.CurrentPage=e.currentPage,this.ToolFormSearch()}},created:function(){this.GetArgParam(),this.LoadRoleNurse(),this.ToolFormSearch();var e=this.$router.currentRoute.path.slice(1,this.$router.currentRoute.path.length);this.loadElementsForRouter("elementlist",e)}},c={render:function(){var e=this,t=e.$createElement,o=e._self._c||t;return o("div",{staticClass:"arghourinit-panel"},[o("div",{staticClass:"top-tool-inputDiv"},[o("el-form",{attrs:{model:e.ToolForm,inline:!0,"label-position":"right"},nativeOn:{submit:function(e){e.preventDefault()}}},[o("el-form-item",{attrs:{label:e.$t("menu.ArgHourInit.5nrnarc4ioc0"),prop:"Ward"}},[o("el-input",{staticStyle:{width:"140px"},attrs:{placeholder:e.$t("menu.ArgHourInit.5nrnarc6xt80"),clearable:"",size:"mini"},model:{value:e.ToolForm.Name,callback:function(t){e.$set(e.ToolForm,"Name",t)},expression:"ToolForm.Name"}})],1),e._v(" "),o("el-form-item",[o("hgbutton",{attrs:{type:"default",styleCode:e.styleCode,icon:"nm-icon-w-find"},on:{click:e.ToolFormSearch}},[e._v(e._s(e.$t("menu.ArgHourInit.5nrnarc70as0")))])],1)],1)],1),e._v(" "),o("div",{staticClass:"top-tool-button"},[0==this.$store.state.login.LoginId||e.elementlist.houradd?o("hgbutton",{attrs:{type:"text",issvg:e.styleCode,icon:e.styleCode?"#nm-icon-add":"nm-icon-lite-add"},on:{click:e.AddClick}},[e._v(e._s(e.$t("menu.ArgHourInit.5nrnarc729o0")))]):e._e(),e._v(" "),0==this.$store.state.login.LoginId||e.elementlist.hourdelete?o("hgbutton",{attrs:{type:"text",issvg:e.styleCode,icon:e.styleCode?"#nm-icon-cancel":"nm-icon-lite-cancel"},on:{click:e.DeleteClick}},[e._v(e._s(e.$t("menu.ArgHourInit.5nrnarc73gk0")))]):e._e()],1),e._v(" "),o("div",{staticClass:"top-tool-table"},[o("el-table",{attrs:{data:e.TableData,"highlight-current-row":"",border:e.styleCode,"header-cell-style":e.headerCellFontWeight,height:e.styleCode?e.Height-130:e.Height-124},on:{"row-click":e.RowClick,"row-dblclick":e.RowDblClick}},[o("el-table-column",{attrs:{type:"index",align:"center",width:"40"}}),e._v(" "),o("el-table-column",{attrs:{label:e.$t("menu.ArgHourInit.5nrnarc4ioc0"),prop:"ArgPerName"}}),e._v(" "),o("el-table-column",{attrs:{label:e.$t("menu.ArgHourInit.5nrnarcb8300"),prop:"ArgHour"}}),e._v(" "),o("el-table-column",{attrs:{label:e.$t("menu.ArgHourInit.5ncy61gaxbc0"),prop:"ArgDate"}}),e._v(" "),o("el-table-column",{attrs:{label:e.$t("menu.ArgHourInit.5nrnarcdddo0"),prop:"CreatorName"}}),e._v(" "),o("el-table-column",{attrs:{label:e.$t("menu.ArgHourInit.5nrnarceq6w0"),prop:"CreateDate"}})],1),e._v(" "),o("hgpagination",{attrs:{styleCode:e.styleCode,sizes:[20,40,50,100],totalCount:e.TotalCount,pageNumber:e.CurrentPage,pageSize:e.PageSize},on:{changePage:e.HandleCurrentChange,getPageSize:e.HandleSizeChange}})],1),e._v(" "),o("el-dialog",{attrs:{title:0==e.winFlag?e.$t("menu.ArgHourInit.5ncy61gayos9"):e.$t("menu.ArgHourInit.5ncy61gayos10"),visible:e.DialogVisible,"close-on-click-modal":!1,width:"350px",align:"center"},on:{"update:visible":function(t){e.DialogVisible=t}}},[o("div",{staticClass:"dialog-header-title",attrs:{slot:"title"},slot:"title"},[e.styleCode?o("i",{class:[0==e.winFlag?"nm-icon-w-plus":"nm-icon-w-edit"]}):e._e(),e._v(" "),0==e.winFlag?o("span",[e._v(e._s(e.$t("menu.ArgHourInit.5ncy61gayos9")))]):1==e.winFlag?o("span",[e._v(e._s(e.$t("menu.ArgHourInit.5ncy61gayos10")))]):e._e()]),e._v(" "),o("div",{directives:[{name:"loading",rawName:"v-loading",value:e.SaveLoading,expression:"SaveLoading"}],attrs:{"element-loading-text":e.$t("menu.ArgHourInit.5nrnarch4z40")}},[o("el-form",{ref:"RecForm",attrs:{model:e.RecForm,rules:e.Rules,inline:!0,"label-position":"right","label-width":"96px"}},[o("el-row",[o("el-form-item",{attrs:{label:e.$t("menu.ArgHourInit.5nrnarc4ioc0"),prop:"Per"}},[o("el-select",{staticStyle:{width:"150px"},attrs:{filterable:"",size:"mini"},model:{value:e.RecForm.Per,callback:function(t){e.$set(e.RecForm,"Per",t)},expression:"RecForm.Per"}},e._l(e.WardNurseStore,function(t){return o("el-option",{key:t.Per,attrs:{value:t.Per,label:t.PerName}},[o("span",{staticStyle:{float:"left"}},[e._v(e._s(t.PerName))]),e._v(" "),o("span",{staticStyle:{color:"#8492a6","font-size":"13px"}},[e._v(e._s(t.PerID))]),e._v(" "),o("span",{staticStyle:{float:"right",color:"#8492a6","font-size":"13px"}},[e._v(e._s(t.PerWard))])])}),1)],1)],1),e._v(" "),o("el-row",[o("el-form-item",{attrs:{label:e.$t("menu.ArgHourInit.5ncy61gaxbc0"),prop:"StDate"}},[o("el-date-picker",{staticStyle:{width:"150px"},attrs:{"picker-options":e.PickerOptions,size:"mini"},model:{value:e.RecForm.StDate,callback:function(t){e.$set(e.RecForm,"StDate",t)},expression:"RecForm.StDate"}})],1)],1),e._v(" "),o("el-row",[o("el-form-item",{attrs:{label:e.$t("menu.ArgHourInit.5ncy61gb2o40"),prop:"Hour"}},[o("el-input-number",{staticStyle:{width:"150px"},attrs:{size:"mini"},model:{value:e.RecForm.Hour,callback:function(t){e.$set(e.RecForm,"Hour",t)},expression:"RecForm.Hour"}})],1)],1)],1),e._v(" "),o("div",{staticClass:"bottom-button"},[o("hgbutton",{attrs:{type:"default"},on:{click:e.SaveHour}},[e._v(e._s(e.$t("menu.ArgHourInit.5nrnarcj88g0")))]),e._v(" "),o("hgbutton",{attrs:{type:"default"},on:{click:function(t){e.DialogVisible=!1}}},[e._v(e._s(e.$t("menu.ArgHourInit.5nrnarcj9bk0")))])],1)],1)])],1)},staticRenderFns:[]};var u=o("VU/8")(l,c,!1,function(e){o("y3hs")},null,null);t.default=u.exports},y3hs:function(e,t){}});