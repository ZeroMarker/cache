webpackJsonp([304],{YA8v:function(e,t){},aTaN:function(e,t,o){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var s=o("Dd8w"),r=o.n(s),a=o("XlQt"),l=o("W5Fe"),n=o("NYxO"),i={components:{hgbutton:a.default,hgpagination:l.default},name:"QualItemGroup",computed:r()({},Object(n.b)(["styleCode"])),data:function(){return{TableHeight:document.body.offsetHeight-120-93-32,PageSize:20,CurrentPage:1,TotalCount:0,TableData:[],LabelWidth:"width:250px",DialogVisible:!1,EditForm:{GroupLevel:"",GroupDesc:"",GroupMember:[],GroupRemark:"",rw:""},rules:{GroupLevel:[{required:!0,message:"请选择级别",trigger:"change"}],GroupDesc:[{required:!0,message:"请输入组名",trigger:"blur"}],GroupMember:[{required:!0,message:"请选择组员",trigger:"change",type:"array"}]},CheckPersonStore:[],GroupLevels:[],SelRow:"",winFlag:0}},methods:{LoadCheckGroupLevels:function(){var e=this;e.GroupLevels=new Array,e.$ajax.request(e.axiosConfig("web.INMQualControlComm","GetCheckLevel","Method","nurseid$"+sessionStorage.loginID)).then(function(t){t.data instanceof Array?e.GroupLevels=[{Code:"H",Desc:"护理部"}]:e.$message({type:"error",message:"获取检查级别失败",showClose:!0,customClass:"error_class"})}).catch(function(t){e.$message({type:"error",message:"获取检查级别失败",showClose:!0,customClass:"error_class"})})},FindClick:function(){var e=this,t=(e.CurrentPage-1)*e.PageSize,o=e.PageSize;e.TableData=new Array,e.$ajax.request(e.axiosConfig("web.INMQualControlComm","FindQualGroup","RecQuery","nurseid$"+sessionStorage.loginID,"start$"+t,"limit$"+o)).then(function(t){t instanceof Object?(e.TableData=t.data.rows,e.TotalCount=parseInt(t.data.results),e.SelRow=""):e.$message({type:"error",message:"获取检查组失败",showClose:!0,customClass:"error_class"})}).catch(function(t){e.$message({type:"error",message:"获取检查组失败",showClose:!0,customClass:"error_class"})})},AddClick:function(){var e=this;this.winFlag=0,this.DialogVisible=!0,this.$nextTick(function(){e.$refs.EditForm.resetFields(),e.EditForm.rw="",e.CheckPersonStore=new Array})},GroupLevelChange:function(){this.EditForm.GroupMember=new Array,this.LoadCheckPerSon()},LoadCheckPerSon:function(){var e=this;e.EditForm.GroupLevel&&(e.CheckPersonStore=new Array,e.$ajax.request(e.axiosConfig("web.INMQualControlComm","FindCheckPersons","RecQuery","level$"+e.EditForm.GroupLevel,"nurseid$"+sessionStorage.loginID)).then(function(t){t instanceof Object?e.CheckPersonStore=t.data.rows:e.$message({type:"error",message:"获取检查人员失败",showClose:!0,customClass:"error_class"})}).catch(function(t){e.$message({type:"error",message:"获取检查人员失败",showClose:!0,customClass:"error_class"})}))},SaveClick:function(){var e=this;e.$refs.EditForm.validate(function(t){if(t){var o=e.EditForm.GroupLevel+"^"+e.EditForm.GroupDesc+"^"+e.EditForm.GroupMember.join(",")+"^"+e.EditForm.GroupRemark+"^"+e.EditForm.rw;e.$ajax.request(e.axiosConfig("web.INMQualControlComm","SaveCheckGroup","Method","parr$"+o,"nurseid$"+sessionStorage.loginID)).then(function(t){1==t.data?(e.$message({type:"success",message:"保存成功",showClose:!0,customClass:"success_class"}),e.DialogVisible=!1,e.FindClick()):e.$message({type:"error",message:"保存失败",showClose:!0,customClass:"error_class"})}).catch(function(t){e.$message({type:"error",message:"保存失败",showClose:!0,customClass:"error_class"})})}})},DeleteClick:function(){var e=this;e.SelRow.rw?e.$confirm("此操作将删除该记录, 是否继续?","提示",{confirmButtonText:"确定",cancelButtonText:"关闭",closeOnClickModal:!1,type:"warning"}).then(function(){var t=e.axiosConfig("web.INMQualControlComm","DeleteCheckGroup","Method","id$"+e.SelRow.rw);e.$ajax.request(t).then(function(t){1==t.data?(e.$message({type:"success",message:"删除成功",showClose:!0,customClass:"success_class"}),e.FindClick()):e.$message({type:"error",message:"删除失败",showClose:!0,customClass:"error_clas"})}).catch(function(t){e.$message({type:"error",message:"删除失败",showClose:!0,customClass:"error_clas"})})}).catch(function(){e.$message({type:"info",message:"取消删除",showClose:!0,customClass:"info_class"})}):e.$message({type:"warning",message:"请选择一行记录！",showClose:!0,customClass:"warning_class"})},EditClick:function(){var e=this,t=this;if(t.winFlag=1,t.SelRow.rw){t.DialogVisible=!0;var o=this.axiosConfig("web.INMQualControlComm","GetQualGroup","RecMethod","id$"+t.SelRow.rw);this.$ajax.request(o).then(function(o){if(o instanceof Object){var s={GroupDesc:o.data.GroupDesc,GroupLevel:o.data.GroupLevel,GroupMember:o.data.GroupMember?o.data.GroupMember.split(","):[],GroupRemark:o.data.GroupRemark,rw:o.data.rw};t.EditForm=s,e.LoadCheckPerSon()}else t.$message({type:"error",message:"获取数据失败",showClose:!0,customClass:"error_class"})}).catch(function(e){t.$message({type:"error",message:"获取数据失败",showClose:!0,customClass:"error_class"})})}else t.$message({type:"warning",message:"请选择一行记录！",showClose:!0,customClass:"warning_class"})},HandleSizeChange:function(e){this.PageSize=e,this.FindClick()},HandleCurrentChange:function(e){this.CurrentPage=e.currentPage,this.FindClick()},RowDbclick:function(e){this.SelRow=e,this.EditClick()},RowClick:function(e){this.SelRow=e}},created:function(){this.LoadCheckGroupLevels(),this.FindClick()}},u={render:function(){var e=this,t=e.$createElement,o=e._self._c||t;return o("div",{staticClass:"qual-itemgroup-panel"},[o("div",{staticClass:"per-top-tool-button dialog-div-top-radius"},[o("hgbutton",{attrs:{type:"text",issvg:e.styleCode,icon:e.styleCode?"#nm-icon-add":"nm-icon-lite-add"},on:{click:e.AddClick}},[e._v(e._s(e.$t("menu.QualItemGroup.5nrnbt3lf380")))]),e._v(" "),o("hgbutton",{attrs:{type:"text",issvg:e.styleCode,icon:e.styleCode?"#nm-icon-edit":"nm-icon-lite-write-order"},on:{click:e.EditClick}},[e._v(e._s(e.$t("menu.QualItemGroup.5nrnbt3lfxg0")))]),e._v(" "),o("hgbutton",{attrs:{type:"text",issvg:e.styleCode,icon:e.styleCode?"#nm-icon-cancel":"nm-icon-lite-cancel"},on:{click:e.DeleteClick}},[e._v(e._s(e.$t("menu.QualItemGroup.5nrnbt3lga80")))])],1),e._v(" "),o("div",{staticClass:"top-tool-dialog-table dialog-table-bottom-radius"},[o("el-table",{ref:"TableData",attrs:{"highlight-current-row":!0,data:e.TableData,"header-cell-style":e.headerCellFontWeight,border:e.styleCode,height:"400"},on:{"row-click":e.RowClick,"row-dblclick":e.RowDbclick}},[o("el-table-column",{attrs:{type:"index",width:"40",align:"center"}}),e._v(" "),o("el-table-column",{attrs:{prop:"GroupLevelDesc",label:e.$t("menu.QualItemGroup.5ncy6m0r7vo0"),"show-overflow-tooltip":"",width:"250","header-align":"left"}}),e._v(" "),o("el-table-column",{attrs:{prop:"GroupDesc",label:e.$t("menu.QualItemGroup.5ncy6m0rads0"),"show-overflow-tooltip":"",width:"250","header-align":"left"}}),e._v(" "),o("el-table-column",{attrs:{prop:"GroupMemberDesc",label:e.$t("menu.QualItemGroup.5ncy6m0raxs0"),"show-overflow-tooltip":"",width:"300","header-align":"left"}}),e._v(" "),o("el-table-column",{attrs:{prop:"GroupRemark",label:e.$t("menu.QualItemGroup.5nrnbt3ospo0"),"show-overflow-tooltip":"",width:"200","header-align":"left"}})],1),e._v(" "),o("hgpagination",{attrs:{styleCode:e.styleCode,sizes:[20,40,50,100],totalCount:e.TotalCount,pageNumber:e.CurrentPage,pageSize:e.PageSize},on:{changePage:e.HandleCurrentChange,getPageSize:e.HandleSizeChange}})],1),e._v(" "),o("el-dialog",{attrs:{title:0==e.winFlag?e.$t("menu.QualItemGroup.5nrnbt3lf380"):e.$t("menu.QualItemGroup.5nrnbt3lfxg0"),modal:"",visible:e.DialogVisible,"modal-append-to-body":!1,"append-to-body":!0,"close-on-click-modal":!1,width:"400px",align:"center"},on:{"update:visible":function(t){e.DialogVisible=t}}},[o("div",{staticClass:"dialog-header-title",attrs:{slot:"title"},slot:"title"},[e.styleCode?o("i",{class:[0==e.winFlag?"nm-icon-w-plus":"nm-icon-w-edit"]}):e._e(),e._v(" "),0==e.winFlag?o("span",[e._v(e._s(e.$t("menu.QualItemGroup.5nrnbt3lf380")))]):1==e.winFlag?o("span",[e._v(e._s(e.$t("menu.QualItemGroup.5nrnbt3lfxg0")))]):e._e()]),e._v(" "),o("el-form",{ref:"EditForm",attrs:{model:e.EditForm,rules:e.rules,inline:!0,"label-position":"right","label-width":"72px"}},[o("el-form-item",{attrs:{label:e.$t("menu.QualItemGroup.5nrnbt3rsy80"),prop:"GroupLevel"}},[o("el-select",{style:e.LabelWidth,attrs:{filterable:"",placeholder:e.$t("menu.QualItemGroup.5nrnbt3te7c0"),size:"mini"},model:{value:e.EditForm.GroupLevel,callback:function(t){e.$set(e.EditForm,"GroupLevel",t)},expression:"EditForm.GroupLevel"}},e._l(e.GroupLevels,function(t){return o("el-option",{key:t.Code,attrs:{value:t.Code,label:t.Desc},nativeOn:{click:function(t){return e.GroupLevelChange(t)}}})}),1)],1),e._v(" "),o("el-form-item",{attrs:{label:e.$t("menu.QualItemGroup.5nrnbt3uiqs0"),prop:"GroupDesc"}},[o("el-input",{style:e.LabelWidth,attrs:{size:"mini",placeholder:e.$t("menu.QualItemGroup.5nrnbt3viok0")},model:{value:e.EditForm.GroupDesc,callback:function(t){e.$set(e.EditForm,"GroupDesc",t)},expression:"EditForm.GroupDesc"}})],1),e._v(" "),o("el-form-item",{attrs:{label:e.$t("menu.QualItemGroup.5nrnbt3x3j40"),prop:"GroupMember"}},[o("el-select",{style:e.LabelWidth,attrs:{multiple:"",clearable:"",filterable:"","collapse-tags":"",placeholder:e.$t("menu.QualItemGroup.5nrnbt3y5yo0"),size:"mini"},model:{value:e.EditForm.GroupMember,callback:function(t){e.$set(e.EditForm,"GroupMember",t)},expression:"EditForm.GroupMember"}},e._l(e.CheckPersonStore,function(e){return o("el-option",{key:e.rw,attrs:{value:e.rw,label:e.PerName}})}),1)],1),e._v(" "),o("el-form-item",{attrs:{label:e.$t("menu.QualItemGroup.5nrnbt3ospo0"),prop:"GroupRemark"}},[o("el-input",{style:e.LabelWidth,attrs:{type:"textarea",placeholder:e.$t("menu.QualItemGroup.5nrnbt41fhw0"),rows:2,size:"mini"},model:{value:e.EditForm.GroupRemark,callback:function(t){e.$set(e.EditForm,"GroupRemark",t)},expression:"EditForm.GroupRemark"}})],1)],1),e._v(" "),o("div",{staticClass:"bottom-button"},[o("hgbutton",{attrs:{type:e.styleCode?"default":"success",styleCode:e.styleCode},on:{click:e.SaveClick}},[e._v(e._s(e.$t("menu.QualItemGroup.5nrnbt41gwg0")))]),e._v(" "),o("hgbutton",{attrs:{type:"default",styleCode:e.styleCode},on:{click:function(t){e.DialogVisible=!1}}},[e._v(e._s(e.$t("menu.QualItemGroup.5nrnbt41h9s0")))])],1)],1)],1)},staticRenderFns:[]};var c=o("VU/8")(i,u,!1,function(e){o("YA8v")},null,null);t.default=c.exports}});