webpackJsonp([241],{TQkR:function(e,t){},aL9n:function(e,t,n){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var l=n("Dd8w"),i=n.n(l),a=n("NYxO"),o=n("XlQt"),s=n("W5Fe"),r=n("doZQ"),u={components:{hgbutton:o.default,hgpagination:s.default,hgswitch:r.default},computed:i()({},Object(a.b)(["Height","DeveloperMode","styleCode"])),data:function(){return{currentPage:1,currentPageSize:20,totalCount:0,dialogVisible:!1,selRow:"",finds:{findcode:"",finddesc:"",findmodule:""},ModuleData:[],tableData:[],ParenMenus:[],editForm:{MenuCode:"",MenuDesc:"",MenuModuleDR:"",MenuParentDR:"",MenuPath:"",MenuRouter:"",MenuLink:"",MenuParams:"",MenuIcon:"",MenuSort:"",MenuStDate:"",MenuEndDate:"",rw:"",IsAdvanced:"Y"},rules:{MenuCode:[{required:!0,message:"请输入菜单代码！",trigger:"blur"}],MenuDesc:[{required:!0,message:"请输入菜单名称！",trigger:"blur"}],MenuModuleDR:[{required:!0,message:"请选择所属模块！",trigger:"change"}],MenuStDate:[{required:!0,message:"请选择启用日期！",trigger:"change",type:"date"}]},changeSort:!0,elementlistvisible:!1,elementtable:[],elrowstyle:{height:"20px"},elementvisible:!1,elementeditform:{elementid:"",elementdesc:"",elementtype:"button",RowID:""},elementrules:{elementid:[{required:!0,message:"请输入元素ID",trigger:"blur"}],elementdesc:[{required:!0,message:"请输入元素描述",trigger:"blur"}],elementtype:[{required:!0,message:"请选择元素类型",trigger:"change"}]},elementtypestore:[{code:"button",desc:"button"}],elementPagesize:20,elementCurrentPage:1,elementTotalCount:0,winFlag:0}},created:function(){this.GetModule(),this.FindClick()},watch:{"editForm.MenuModuleDR":{handler:function(e,t){this.editForm.MenuParentDR="",this.GetParentMenu(),this.changeSort&&this.GetMenuSort(),this.changeSort=!0}},"editForm.MenuSort":{handler:function(e,t){this.editForm.MenuSort=parseInt(e)},deep:!0},"editForm.MenuStDate":{handler:function(e,t){""==e&&(e=null),!e instanceof Date&&(this.editForm.MenuStDate=new Date(e.replace(/-/g,"/")))},deep:!0},"editForm.MenuEndDate":{handler:function(e,t){""==e&&(e=null),!e instanceof Date&&(this.editForm.MenuEndDate=new Date(e.replace(/-/g,"/")))},deep:!0},currentPage:function(e,t){this.FindClick()}},methods:{HandleElementSizeChange:function(e){this.elementPagesize=e,this.LoadElementData()},HandleElementCurrentChange:function(e){this.elementCurrentPage=e.currentPage,this.LoadElementData()},SaveElementData:function(e){var t=this,n="";for(var l in t[e]){var i=t[e][l];n=n?n+"^"+l+"|"+i:l+"|"+i}n="par|"+t.selRow.rw+"^"+n,t.$refs[e].validate(function(e){e&&t.$ajax.request(t.axiosConfig("web.INMSetComm","SaveElementData","Method","parr$"+n)).then(function(e){2!=e.data?(t.elementvisible=!1,t.$message({type:"success",message:"保存成功",showClose:!0,customClass:"success_class"}),t.LoadElementData()):t.$message({type:"warning",message:"此记录已经存在",showClose:!0,customClass:"warning_class"})})})},LoadMenuData:function(){var e=this;e.$ajax.request(e.axiosConfig("web.INMSetComm","GetMenu","RecMethod","id$"+e.$route.params.menuid)).then(function(t){e.elementform.menucode=t.data.MenuCode,e.elementform.menudesc=t.data.MenuDesc})},LoadElementData:function(){var e=this;e.$ajax.request(e.axiosConfig("web.INMSetComm","FindMenuElement","RecQuery","start$"+(e.elementCurrentPage-1)*e.elementPagesize,"limit$"+e.elementPagesize,"par$"+e.selRow.rw)).then(function(t){e.elementtable=t.data.rows,e.elementTotalCount=parseInt(t.data.results)})},AddElementClick:function(){var e=this;e.winFlag=0,e.elementvisible=!0,e.$nextTick(function(){e.$refs.elementeditform.resetFields()}),e.ClearForm()},ClearForm:function(){this.elementeditform={elementid:"",elementdesc:"",elementtype:"button",RowID:""}},RowDblClickEvent:function(e,t){var n=this;n.winFlag=1,n.elementvisible=!0,n.$nextTick(function(){n.$refs.elementeditform.resetFields(),n.$ajax.request(n.axiosConfig("web.INMSetComm","GetElementData","RecMethod","par$"+e.par,"rw$"+e.rowid)).then(function(e){n.elementeditform=e.data})})},HandleClose:function(e){e()},HandleCurrentChange:function(e){this.currentPage=e.currentPage,this.FindClick()},HandleSizeChange:function(e){this.currentPageSize=e,this.FindClick()},GetModule:function(){var e=this,t=e.axiosConfig("web.INMSetComm","FindModuleList","RecQuery");e.$ajax.request(t).then(function(t){e.ModuleData=t.data.rows}).catch(function(e){})},GetParentMenu:function(){var e=this,t=e.axiosConfig("web.INMSetComm","FindMenuList","RecQuery","parr$^^"+e.editForm.MenuModuleDR);e.$ajax.request(t).then(function(t){e.ParenMenus=t.data.rows}).catch(function(e){})},RowClick:function(e){this.selRow=e},RowDblClick:function(e){this.selRow=e;var t=this;if(t.winFlag=1,t.DeveloperMode){if(""!=e.rw){var n=this.axiosConfig("web.INMSetComm","GetMenu","RecMethod","id$"+e.rw);this.$ajax.request(n).then(function(e){t.dialogVisible=!0,t.$nextTick(function(){t.$refs.editForm.resetFields(),t.setForm(t.$refs.editForm,t.editForm,e.data),t.$nextTick(function(){e.data.MenuParentDR&&(t.editForm.MenuParentDR=e.data.MenuParentDR)})})}).catch(function(e){}),t.changeSort=!1}}else t.$message({type:"warning",message:"非开发者不可编辑",showClose:!0,customClass:"ward_class"})},FindClick:function(){var e=this,t=e.finds.findcode+"^"+e.finds.finddesc+"^"+e.finds.findmodule,n=(this.currentPage-1)*this.currentPageSize,l=this.currentPageSize,i=e.axiosConfig("web.INMSetComm","FindMenuList","RecQuery","parr$"+t,"start$"+n,"limit$"+l);e.$ajax.request(i).then(function(t){e.tableData=t.data.rows,e.totalCount=parseInt(t.data.results),e.selRow=""}).catch(function(e){})},AddClick:function(){var e=this;e.winFlag=0,e.dialogVisible=!0,e.GetMenuSort(),e.changeSort=!0,e.$nextTick(function(){e.$refs.editForm.resetFields(),e.editForm.MenuStDate=new Date,e.editForm.IsAdvanced="Y",e.editForm.rw=""})},SaveClick:function(){var e=this;this.$refs.editForm.validate(function(t){if(!t)return!1;var n="";for(var l in e.editForm)void 0==e.editForm[l]&&(e.editForm[l]=""),n=e.editForm[l]instanceof Date?n+l+"|"+e.editForm[l].Format("yyyy-MM-dd")+"^":n+l+"|"+e.editForm[l].toString()+"^";""!=n&&e.$ajax.request(e.axiosConfig("web.INMSetComm","IsExistMenu","Method","parr$"+n)).then(function(t){-1!=t.data?e.$ajax.request(e.axiosConfig("web.INMSetComm","SaveMenu","Method","parr$"+n)).then(function(t){1==t.data?(e.$message({message:"保存成功！",type:"success",showClose:!0,customClass:"success_class"}),e.dialogVisible=!1,e.FindClick()):t.data.length<100?e.$message({message:t.data,type:"error",showClose:!0,customClass:"error_class"}):e.$message({message:"保存失败！请联系开发^_^",type:"error",showClose:!0,customClass:"error_class"})}).catch(function(t){e.$message({message:"保存失败！",type:"error",showClose:!0,customClass:"error_class"})}):e.$message({type:"warning",message:"该菜单代码已存在，保存失败",showClose:!0,customClass:"warning_class"})})})},GetMenuSort:function(){var e=this,t=e.axiosConfig("web.INMSetComm","GetMaxMenuSort","Method","module$"+e.editForm.MenuModuleDR);e.$ajax.request(t).then(function(t){""!=t.data?e.editForm.MenuSort=parseInt(t.data):e.editForm.MenuSort=1}).catch(function(e){})},ElementClick:function(){var e=this;e.selRow?(e.elementlistvisible=!0,e.$nextTick(function(){e.elementCurrentPage=1,e.LoadElementData()})):e.$message({message:"请选择一条记录！",type:"warning",showClose:!0,customClass:"warning_class"})}}},d={render:function(){var e=this,t=e.$createElement,n=e._self._c||t;return n("div",{staticClass:"menu-set-panel"},[n("div",{staticClass:"top-tool-inputDiv"},[n("el-form",{ref:"finds",attrs:{model:e.finds,inline:!0},nativeOn:{submit:function(e){e.preventDefault()}}},[n("el-form-item",{attrs:{label:e.$t("menu.MenuSet.5nrnc5j5dd00")}},[n("el-select",{staticStyle:{width:"140px"},attrs:{clearable:"",size:"mini",placeholder:e.$t("menu.MenuSet.5nrnc5j6j2w0")},on:{change:e.FindClick},model:{value:e.finds.findmodule,callback:function(t){e.$set(e.finds,"findmodule",t)},expression:"finds.findmodule"}},e._l(e.ModuleData,function(e){return n("el-option",{key:e.rw,attrs:{label:e.ModuleDesc,value:e.rw}})}),1)],1),e._v(" "),n("el-form-item",{attrs:{label:e.$t("menu.MenuSet.5nrnc5j7qr00")}},[n("el-input",{staticStyle:{width:"140px"},attrs:{clearable:"",size:"mini"},nativeOn:{keyup:function(t){return!t.type.indexOf("key")&&e._k(t.keyCode,"enter",13,t.key,"Enter")?null:e.FindClick(t)}},model:{value:e.finds.findcode,callback:function(t){e.$set(e.finds,"findcode",t)},expression:"finds.findcode"}})],1),e._v(" "),n("el-form-item",{attrs:{label:e.$t("menu.MenuSet.5nrnc5j8tf40")}},[n("el-input",{staticStyle:{width:"140px"},attrs:{clearable:"",size:"mini"},nativeOn:{keyup:function(t){return!t.type.indexOf("key")&&e._k(t.keyCode,"enter",13,t.key,"Enter")?null:e.FindClick(t)}},model:{value:e.finds.finddesc,callback:function(t){e.$set(e.finds,"finddesc",t)},expression:"finds.finddesc"}})],1),e._v(" "),n("el-form-item",[n("hgbutton",{attrs:{type:"default",styleCode:e.styleCode,icon:"nm-icon-w-find"},on:{click:e.FindClick}},[e._v(e._s(e.$t("menu.MenuSet.5nrnc5j8uts0")))])],1)],1)],1),e._v(" "),n("div",{staticClass:"top-tool-button"},[0==this.$store.state.login.LoginId&&e.DeveloperMode?n("hgbutton",{attrs:{type:"text",issvg:e.styleCode,icon:e.styleCode?"#nm-icon-add":"nm-icon-lite-add"},on:{click:e.AddClick}},[e._v(e._s(e.$t("menu.MenuSet.5nrnc5j8vsw0")))]):e._e(),e._v(" "),n("hgbutton",{attrs:{type:"text",issvg:e.styleCode,icon:e.styleCode?"#nm-icon-rectangle-flow":"nm-icon-lite-rectangle"},on:{click:e.ElementClick}},[e._v(e._s(e.$t("menu.MenuSet.5ncy6tttkg40")))])],1),e._v(" "),n("div",{staticClass:"top-tool-table"},[n("el-table",{ref:"menulist",attrs:{data:e.tableData,height:e.styleCode?e.Height-130:e.Height-124,border:e.styleCode,"header-cell-style":e.headerCellFontWeight,"highlight-current-row":"",align:"left",label:e.$t("menu.MenuSet.5nrnc5j9ugk0")},on:{"row-dblclick":e.RowDblClick,"row-click":e.RowClick}},[n("el-table-column",{attrs:{type:"index",label:"",width:"40",align:"center"}}),e._v(" "),n("el-table-column",{attrs:{prop:"MenuCode",label:e.$t("menu.MenuSet.5ncy6tttll00"),width:"150","show-overflow-tooltip":"","header-align":"left"}}),e._v(" "),n("el-table-column",{attrs:{prop:"MenuDesc",label:e.$t("menu.MenuSet.5ncy6tttlu00"),width:"150","show-overflow-tooltip":"","header-align":"left"}}),e._v(" "),n("el-table-column",{attrs:{prop:"ModuleDesc",label:e.$t("menu.MenuSet.5ncy6tttm1c0"),width:"100","show-overflow-tooltip":"","header-align":"left"}}),e._v(" "),n("el-table-column",{attrs:{prop:"ParentDesc",label:e.$t("menu.MenuSet.5ncy6tttm940"),width:"120","show-overflow-tooltip":"","header-align":"left"}}),e._v(" "),n("el-table-column",{attrs:{prop:"MenuRouter",label:e.$t("menu.MenuSet.5ncy6tttmgc0"),width:"150","show-overflow-tooltip":"","header-align":"left"}}),e._v(" "),n("el-table-column",{attrs:{prop:"MenuPath",label:e.$t("menu.MenuSet.5ncy6tttmno0"),width:"200","show-overflow-tooltip":"","header-align":"left"}}),e._v(" "),n("el-table-column",{attrs:{prop:"MenuLink",label:e.$t("menu.MenuSet.5ncy6tttmv00"),width:"120","show-overflow-tooltip":"","header-align":"left"}}),e._v(" "),n("el-table-column",{attrs:{prop:"MenuParams",label:e.$t("menu.MenuSet.5ncy6tttn280"),width:"100","show-overflow-tooltip":"","header-align":"left"}}),e._v(" "),n("el-table-column",{attrs:{prop:"MenuIcon",label:e.$t("menu.MenuSet.5ncy6tttn9k0"),width:"80","show-overflow-tooltip":"","header-align":"left"}}),e._v(" "),n("el-table-column",{attrs:{prop:"MenuSort",label:e.$t("menu.MenuSet.5nrnc5jbd4w0"),width:"80","show-overflow-tooltip":"","header-align":"left"}}),e._v(" "),n("el-table-column",{attrs:{prop:"MenuStDate",label:e.$t("menu.MenuSet.5nrnc5jcfio0"),width:"100","show-overflow-tooltip":"","header-align":"left",formatter:e.PTableDateHisShow}}),e._v(" "),n("el-table-column",{attrs:{prop:"MenuEndDate",label:e.$t("menu.MenuSet.5nrnc5jdy2w0"),width:"100","show-overflow-tooltip":"","header-align":"left",formatter:e.PTableDateHisShow}}),e._v(" "),e._e()],1),e._v(" "),n("hgpagination",{attrs:{styleCode:e.styleCode,sizes:[20,40,50,100],totalCount:e.totalCount,pageNumber:e.currentPage,pageSize:e.currentPageSize},on:{changePage:e.HandleCurrentChange,getPageSize:e.HandleSizeChange}})],1),e._v(" "),n("div",[n("el-dialog",{attrs:{title:0==e.winFlag?e.$t("menu.MenuSet.5nrnc5j8vsw0"):e.$t("menu.MenuSet.5nrnc5j8vsw1"),visible:e.dialogVisible,"close-on-click-modal":!1,width:"554px",align:"center"},on:{"update:visible":function(t){e.dialogVisible=t}}},[n("div",{staticClass:"dialog-header-title",attrs:{slot:"title"},slot:"title"},[e.styleCode?n("i",{class:[0==e.winFlag?"nm-icon-w-plus":"nm-icon-w-edit"]}):e._e(),e._v(" "),0==e.winFlag?n("span",[e._v(e._s(e.$t("menu.MenuSet.5nrnc5j8vsw0")))]):1==e.winFlag?n("span",[e._v(e._s(e.$t("menu.MenuSet.5nrnc5j8vsw1")))]):e._e()]),e._v(" "),n("el-form",{ref:"editForm",attrs:{model:e.editForm,rules:e.rules,"label-width":"100px",inline:"","label-position":"right",align:"left"}},[n("el-form-item",{attrs:{label:e.$t("menu.MenuSet.5ncy6tttll00"),prop:"MenuCode"}},[n("el-input",{staticStyle:{width:"150px"},attrs:{disabled:!!e.editForm.rw,clearable:"",placeholder:e.$t("menu.MenuSet.5ncy6tttq4o0"),size:"mini"},model:{value:e.editForm.MenuCode,callback:function(t){e.$set(e.editForm,"MenuCode",t)},expression:"editForm.MenuCode"}})],1),e._v(" "),n("el-form-item",{attrs:{label:e.$t("menu.MenuSet.5ncy6tttqc40"),prop:"MenuDesc"}},[n("el-input",{staticStyle:{width:"150px"},attrs:{clearable:"",placeholder:e.$t("menu.MenuSet.5ncy6tttqks0"),size:"mini"},model:{value:e.editForm.MenuDesc,callback:function(t){e.$set(e.editForm,"MenuDesc",t)},expression:"editForm.MenuDesc"}})],1),e._v(" "),n("el-form-item",{attrs:{label:e.$t("menu.MenuSet.5ncy6tttm1c0"),prop:"MenuModuleDR"}},[n("el-select",{staticStyle:{width:"150px"},attrs:{clearable:"",placeholder:e.$t("menu.MenuSet.5ncy6tttroc0"),size:"mini"},model:{value:e.editForm.MenuModuleDR,callback:function(t){e.$set(e.editForm,"MenuModuleDR",t)},expression:"editForm.MenuModuleDR"}},e._l(e.ModuleData,function(e){return n("el-option",{key:e.rw,attrs:{label:e.ModuleDesc,value:e.rw}})}),1)],1),e._v(" "),n("el-form-item",{attrs:{label:e.$t("menu.MenuSet.5ncy6tttm940"),prop:"MenuParentDR"}},[n("el-select",{staticStyle:{width:"150px"},attrs:{clearable:"",placeholder:e.$t("menu.MenuSet.5nrnc5j6j2w0"),size:"mini"},model:{value:e.editForm.MenuParentDR,callback:function(t){e.$set(e.editForm,"MenuParentDR",t)},expression:"editForm.MenuParentDR"}},e._l(e.ParenMenus,function(e){return n("el-option",{key:e.rw,attrs:{label:e.MenuDesc,value:e.rw}})}),1)],1),e._v(" "),n("el-form-item",{attrs:{label:e.$t("menu.MenuSet.5ncy6tttspo0"),prop:"MenuRouter"}},[n("el-input",{staticStyle:{width:"150px"},attrs:{clearable:"",placeholder:e.$t("menu.MenuSet.5ncy6tttsx80"),size:"mini"},model:{value:e.editForm.MenuRouter,callback:function(t){e.$set(e.editForm,"MenuRouter",t)},expression:"editForm.MenuRouter"}})],1),e._v(" "),n("el-form-item",{attrs:{label:e.$t("menu.MenuSet.5ncy6tttmno0"),prop:"MenuPath"}},[n("el-input",{staticStyle:{width:"150px"},attrs:{clearable:"",placeholder:e.$t("menu.MenuSet.5ncy6tttt9s0"),size:"mini"},model:{value:e.editForm.MenuPath,callback:function(t){e.$set(e.editForm,"MenuPath",t)},expression:"editForm.MenuPath"}})],1),e._v(" "),n("el-form-item",{attrs:{label:e.$t("menu.MenuSet.5ncy6tttth40"),prop:"MenuLink"}},[n("el-input",{staticStyle:{width:"150px"},attrs:{clearable:"",size:"mini"},model:{value:e.editForm.MenuLink,callback:function(t){e.$set(e.editForm,"MenuLink",t)},expression:"editForm.MenuLink"}})],1),e._v(" "),n("el-form-item",{attrs:{label:e.$t("menu.MenuSet.5ncy6tttn280"),prop:"MenuParams"}},[n("el-input",{staticStyle:{width:"150px"},attrs:{clearable:"",size:"mini"},model:{value:e.editForm.MenuParams,callback:function(t){e.$set(e.editForm,"MenuParams",t)},expression:"editForm.MenuParams"}})],1),e._v(" "),n("el-form-item",{attrs:{label:e.$t("menu.MenuSet.5ncy6tttn9k0"),prop:"MenuIcon"}},[n("el-input",{staticStyle:{width:"150px"},attrs:{clearable:"",size:"mini"},model:{value:e.editForm.MenuIcon,callback:function(t){e.$set(e.editForm,"MenuIcon",t)},expression:"editForm.MenuIcon"}})],1),e._v(" "),n("el-form-item",{attrs:{label:e.$t("menu.MenuSet.5nrnc5jbd4w0"),prop:"MenuSort"}},[n("el-input-number",{staticStyle:{width:"150px"},attrs:{min:1,max:100,size:"mini"},model:{value:e.editForm.MenuSort,callback:function(t){e.$set(e.editForm,"MenuSort",t)},expression:"editForm.MenuSort"}})],1),e._v(" "),n("el-form-item",{attrs:{label:e.$t("menu.MenuSet.5nrnc5jcfio0"),prop:"MenuStDate"}},[n("el-date-picker",{staticStyle:{width:"150px"},attrs:{clearable:"",type:"date",format:this.$store.state.mainframe.DateFormat,placeholder:e.$t("menu.MenuSet.5nrnc5jm0q00"),"default-value":new Date,size:"mini"},model:{value:e.editForm.MenuStDate,callback:function(t){e.$set(e.editForm,"MenuStDate",t)},expression:"editForm.MenuStDate"}})],1),e._v(" "),n("el-form-item",{attrs:{label:e.$t("menu.MenuSet.5nrnc5jdy2w0"),prop:"MenuEndDate"}},[n("el-date-picker",{staticStyle:{width:"150px"},attrs:{clearable:"",type:"date",format:this.$store.state.mainframe.DateFormat,placeholder:e.$t("menu.MenuSet.5nrnc5jm0q00"),size:"mini"},model:{value:e.editForm.MenuEndDate,callback:function(t){e.$set(e.editForm,"MenuEndDate",t)},expression:"editForm.MenuEndDate"}})],1),e._v(" "),e.DeveloperMode?n("el-form-item",{attrs:{label:e.$t("menu.MenuSet.5nrnc5jppu40"),prop:"IsAdvanced"}},[n("hgswitch",{attrs:{"inactive-value":"N","inactive-text":e.$t("menu.MenuSet.5nrnc5jqq880"),"active-value":"Y","active-text":e.$t("menu.MenuSet.5nrnc5jrof00"),disabled:!e.DeveloperMode},model:{value:e.editForm.IsAdvanced,callback:function(t){e.$set(e.editForm,"IsAdvanced",t)},expression:"editForm.IsAdvanced"}})],1):e._e()],1),e._v(" "),n("div",{staticClass:"bottom-button"},[e.DeveloperMode?n("hgbutton",{directives:[{name:"intervalclick",rawName:"v-intervalclick",value:{func:e.SaveClick,time:1e3},expression:"{func:SaveClick,time:1000,}"}],attrs:{type:e.styleCode?"default":"success",styleCode:e.styleCode}},[e._v(e._s(e.$t("menu.MenuSet.5nrnc5jrq580")))]):e._e(),e._v(" "),n("hgbutton",{attrs:{type:"default",styleCode:e.styleCode},on:{click:function(t){e.dialogVisible=!1}}},[e._v(e._s(e.$t("menu.MenuSet.5nrnc5jrqik0")))])],1)],1)],1),e._v(" "),n("div",[n("el-dialog",{attrs:{title:e.$t("menu.MenuSet.5ncy6tttkg40"),visible:e.elementlistvisible,"close-on-click-modal":!1,"custom-class":"el-dialog_list","before-close":e.HandleClose},on:{"update:visible":function(t){e.elementlistvisible=t}}},[n("div",{staticClass:"dialog-header-title",attrs:{slot:"title"},slot:"title"},[e.styleCode?n("i",{staticClass:"nm-icon-w-paper"}):e._e(),e._v(" "),n("span",[e._v(e._s(e.$t("menu.MenuSet.5ncy6tttkg40")))])]),e._v(" "),n("div",{staticClass:"per-top-tool-button dialog-div-top-radius"},[n("hgbutton",{attrs:{type:"text",issvg:e.styleCode,icon:e.styleCode?"#nm-icon-add":"nm-icon-lite-add"},on:{click:e.AddElementClick}},[e._v(e._s(e.$t("menu.MenuSet.5nrnc5j8vsw0")))])],1),e._v(" "),n("div",{staticClass:"top-tool-dialog-table dialog-table-bottom-radius"},[n("el-table",{ref:"elementtable",staticStyle:{width:"100%"},attrs:{"highlight-current-row":!0,"header-cell-style":e.headerCellFontWeight,data:e.elementtable,border:e.styleCode,"row-style":e.elrowstyle,height:"400"},on:{"row-dblclick":e.RowDblClickEvent}},[n("el-table-column",{attrs:{type:"index",width:"40",align:"center"}}),e._v(" "),n("el-table-column",{attrs:{label:e.$t("menu.MenuSet.5ncy6tttzdw0"),prop:"elementId",width:"200"}}),e._v(" "),n("el-table-column",{attrs:{label:e.$t("menu.MenuSet.5nrnc5jt7ys0"),prop:"elementDesc",width:""}}),e._v(" "),n("el-table-column",{attrs:{label:e.$t("menu.MenuSet.5ncy6tttzs40"),prop:"elementType",width:"200"}}),e._v(" "),e._e(),e._v(" "),e._e()],1),e._v(" "),n("hgpagination",{attrs:{styleCode:e.styleCode,sizes:[20,40,50,100],totalCount:e.elementTotalCount,pageNumber:e.elementCurrentPage,pageSize:e.elementPagesize},on:{changePage:e.HandleElementCurrentChange,getPageSize:e.HandleElementSizeChange}})],1)]),e._v(" "),n("el-dialog",{attrs:{title:0==e.winFlag?e.$t("menu.MenuSet.5nrnc5j8vsw0"):e.$t("menu.MenuSet.5nrnc5j8vsw1"),visible:e.elementvisible,"close-on-click-modal":!1,"before-close":e.HandleClose,width:"384px",align:"center"},on:{"update:visible":function(t){e.elementvisible=t}}},[n("div",{staticClass:"dialog-header-title",attrs:{slot:"title"},slot:"title"},[e.styleCode?n("i",{class:[0==e.winFlag?"nm-icon-w-plus":"nm-icon-w-edit"]}):e._e(),e._v(" "),0==e.winFlag?n("span",[e._v(e._s(e.$t("menu.MenuSet.5nrnc5j8vsw0")))]):1==e.winFlag?n("span",[e._v(e._s(e.$t("menu.MenuSet.5nrnc5j8vsw1")))]):e._e()]),e._v(" "),n("el-form",{ref:"elementeditform",attrs:{model:e.elementeditform,rules:e.elementrules,"label-width":"120px",inline:!0,"label-position":"right",align:"left"}},[n("el-form-item",{attrs:{label:e.$t("menu.MenuSet.5ncy6tttzdw0"),prop:"elementid"}},[n("el-input",{staticStyle:{width:"200px"},attrs:{disabled:!!e.elementeditform.RowID,placeholder:e.$t("menu.MenuSet.5nrnc5jurqo0"),size:"mini"},model:{value:e.elementeditform.elementid,callback:function(t){e.$set(e.elementeditform,"elementid",t)},expression:"elementeditform.elementid"}})],1),e._v(" "),n("el-form-item",{attrs:{label:e.$t("menu.MenuSet.5nrnc5jt7ys0"),prop:"elementdesc"}},[n("el-input",{staticStyle:{width:"200px"},attrs:{placeholder:e.$t("menu.MenuSet.5nrnc5jurqo0"),size:"mini"},model:{value:e.elementeditform.elementdesc,callback:function(t){e.$set(e.elementeditform,"elementdesc",t)},expression:"elementeditform.elementdesc"}})],1),e._v(" "),n("el-form-item",{attrs:{label:e.$t("menu.MenuSet.5ncy6tttzs40"),prop:"elementtype"}},[n("el-select",{staticStyle:{width:"200px"},attrs:{filterable:"",clearable:"",placeholder:e.$t("menu.MenuSet.5nrnc5j6j2w0"),size:"mini"},model:{value:e.elementeditform.elementtype,callback:function(t){e.$set(e.elementeditform,"elementtype",t)},expression:"elementeditform.elementtype"}},e._l(e.elementtypestore,function(e){return n("el-option",{key:e.code,attrs:{label:e.desc,value:e.code}})}),1)],1)],1),e._v(" "),n("div",{staticClass:"bottom-button"},[n("hgbutton",{directives:[{name:"intervalclick",rawName:"v-intervalclick",value:{func:e.SaveElementData,time:500,a:"elementeditform"},expression:"{func:SaveElementData,time:500,a:'elementeditform'}"}],attrs:{type:e.styleCode?"default":"success",styleCode:e.styleCode}},[e._v(e._s(e.$t("menu.MenuSet.5nrnc5jrq580")))]),e._v(" "),n("hgbutton",{attrs:{type:"default",styleCode:e.styleCode},on:{click:function(t){e.elementvisible=!1}}},[e._v(e._s(e.$t("menu.MenuSet.5nrnc5jrqik0")))])],1)],1)],1)])},staticRenderFns:[]};var c=n("VU/8")(u,d,!1,function(e){n("TQkR")},null,null);t.default=c.exports}});