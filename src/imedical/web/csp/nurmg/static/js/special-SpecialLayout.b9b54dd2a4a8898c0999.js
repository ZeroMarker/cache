webpackJsonp([155,295],{d6c6:function(t,e,a){"use strict";Object.defineProperty(e,"__esModule",{value:!0});var o=a("5eDb"),i=a.n(o),s=a("iB2v"),l=(a("axCQ"),a("3Oml"),a("NBEC"),a("HaK5"),a("Q/P+"),a("f85y"),a("yXOt"),a("Abny"),a("S0tB"),a("njYm"),a("SlIL"),a("gBhd"),{components:{Editor:s.a},name:"tinymce",props:{value:{type:String,default:""},disabled:{type:Boolean,default:!1},plugins:{type:[String,Array],default:"lists advlist table wordcount preview print link image paste code"},toolbar:{type:[String,Array],default:"styleselect | fontselect fontsizeselect bold italic underline strikethrough superscript subscript removeformat lineheight forecolor backcolor | alignleft aligncenter alignright alignjustify | bullist numlist indent2em outdent indent | table link image media | preview print code"},height:{type:Number,default:300},wordLimit:{type:[Number,Boolean],default:!1},uploadAddress:{type:[String],default:""}},data:function(){var t=this,e="./nurmg/";return{init:{language_url:e+"static/tinymce/langs/zh_CN.js",language:"zh_CN",skin_url:e+"static/tinymce/skins/ui/oxide",content_css:e+"static/tinymce/skins/ui/oxide/content.min.css",external_plugins:{indent2em:"../tinymce/plugins/indent2em/plugin.min.js",lineheight:"../tinymce/plugins/lineheight/plugin.min.js",ax_wordlimit:"../tinymce/plugins/ax_wordlimit/plugin.min.js",media:"../tinymce/plugins/media/plugin.min.js"},height:this.height,plugins:this.plugins,toolbar:this.toolbar,branding:!1,menubar:!1,elementpath:!1,toolbar_mode:"sliding",default_link_target:"_blank",fontsize_formats:"初号=42pt 小初=36pt 一号=26pt 小一=24pt 二号=22pt 小二=18pt 三号=16pt 小三=15pt 四号=14pt 小四=12pt 五号=10.5pt 小五=9pt 六号=7.5pt 小六=6.5pt 七号=5.5pt 八号=5pt 8=8pt 10=10pt 11=11pt 20=20pt",paste_retain_style_properties:"color font-size text-indent text-align margin margin-left margin-top margin-bottom margin-right border border-style border-collapse border-top border-left border-bottom border-right mso-border-top-alt mso-border-left-alt mso-border-alt padding mso-padding-alt",paste_preprocess:function(t,e){e.content=e.content.replace(/font-family:(\S)*?;/gi,"font-family:宋体;"),e.content=e.content.replace(/text-indent: -(\S)*?pt;/gi,"").replace(/windowtext 1.0pt/gi,"1px").replace(/<table/gi,'<table cellspacing="0" cellpadding="0"')},file_picker_callback:function(e,a,o){var i=".jpg, .jpeg, .png, .gif, .pdf, .txt, .zip, .rar, .7z, .doc, .docx, .xls, .xlsx, .ppt, .pptx, .mp3, .mp4";switch(o.filetype){case"image":i=".png, .jpg, .jpeg, .gif";break;case"media":i=".mp3, .mp4";break;case"file":i=".pdf, .txt, .zip, .rar, .7z, .doc, .docx, .xls, .xlsx, .ppt, .pptx"}var s=t.uploadAddress,l=document.createElement("input");l.setAttribute("type","file"),l.setAttribute("accept",i),l.onchange=function(){var t=this.files[0],a=void 0,i=void 0;(a=new XMLHttpRequest).withCredentials=!1,a.open("POST",s),a.onload=function(){if(200==a.status){var i=a.responseText.split(":")[0],l=a.responseText.split(":")[1];if("success"==i)switch(o.filetype){case"image":e(s.split("Fileupdate")[0]+l,{title:t.name,alt:t.name});break;case"media":var n=URL.createObjectURL(t),r=document.createElement("video");r.onloadedmetadata=function(t){URL.revokeObjectURL(n),e(s.split("Fileupdate")[0]+l,{width:r.videoWidth,height:r.videoHeight})},r.src=n,r.load();break;case"file":e(s.split("Fileupdate")[0]+l,{title:t.name,text:t.name})}}},(i=new FormData).append("file",t,t.name),a.send(i)},l.click()},contextmenu:"link linkchecker image imagetools table spellchecker configurepermanentpen media cut copy paste",font_formats:"黑体=黑体;宋体=宋体;新宋体=新宋体;仿宋=仿宋;楷体=楷体;隶书=隶书;微软雅黑=微软雅黑,Microsoft YaHei;等线=等线;方正姚体=方正姚体;方正舒体=方正舒体;华文中宋=华文中宋;华文仿宋=华文仿宋;华文宋体=华文宋体;华文彩云=华文彩云;华文新魏=华文新魏;华文楷体=华文楷体;华文琥珀=华文琥珀;华文细黑=华文细黑;华文行楷=华文行楷;华文隶书=华文隶书;幼圆=幼圆; Andale Mono=andale mono,times; Arial=arial,helvetica,sans-serif; Arial Black=arial black,avant garde; Book Antiqua=book antiqua,palatino; Comic Sans MS=comic sans ms,sans-serif; Courier New=courier new,courier; Georgia=georgia,palatino; Helvetica=helvetica; Impact=impact,chicago; Symbol=symbol; Tahoma=tahoma,arial,helvetica,sans-serif;Times New Roman=times new roman,times; Trebuchet MS=trebuchet ms,geneva;",content_style:"body { font-family:宋体;}",ax_wordlimit_num:this.wordLimit,ax_wordlimit_callback:function(t,e,a){t.notificationManager.open({type:"warning ",text:"当前字数："+e.length+"，限制字数："+a,timeout:2e3,closeButton:!0,icon:"warning"})}},myValue:this.value}},mounted:function(){i.a.init({})},methods:{onClick:function(t){this.$emit("onClick",t,i.a)},clear:function(){this.myValue=""},onBlur:function(t){this.$emit("onBlur",t,i.a)}},watch:{value:function(t){this.myValue=t},myValue:function(t){this.$emit("input",t)}}}),n={render:function(){var t=this,e=t.$createElement,a=t._self._c||e;return a("div",{staticClass:"tinymce-box"},[a("Editor",{attrs:{init:t.init,disabled:t.disabled},on:{onBlur:t.onBlur,onClick:t.onClick},model:{value:t.myValue,callback:function(e){t.myValue=e},expression:"myValue"}})],1)},staticRenderFns:[]};var r=a("VU/8")(l,n,!1,function(t){a("jeM7")},null,null);e.default=r.exports},ePFl:function(t,e){},jeM7:function(t,e){},n6rr:function(t,e,a){"use strict";Object.defineProperty(e,"__esModule",{value:!0});var o=a("Dd8w"),i=a.n(o),s=a("NYxO"),l=a("d6c6"),n=a("XlQt"),r=a("W5Fe"),u=a("z8xk"),c={name:"SpecialLayout",computed:i()({},Object(s.b)(["Height","styleCode"])),components:{tinymce:l.default,hgbutton:n.default,hgpagination:r.default,Hgpanel:u.default},data:function(){return{elementlist:{},ToolForm:{Group:"",StDate:new Date((new Date).setDate(1)),EndDate:(new Date).getMonthDate((new Date).getMonthDay()),Status:""},GroupStore:[],StatusStore:[{value:"N",label:"保存"},{value:"Y",label:"提交"},{value:"A",label:"审核"},{value:"B",label:"驳回"}],LayoutTable:[],TableDataAll:[],CurrentPage:1,PageSize:20,TotalCount:0,LayoutForm:{Group:"",Year:0,StDate:"",EndDate:"",Content:"",rw:""},Rules:{Group:[{required:!0,message:"请选择专业组",trigger:"change"}],Year:[{required:!0,message:"请填写规划期限",trigger:"blur"}],StDate:[{required:!0,message:"请选择活动日期",trigger:"change",type:"date"}],EndDate:[{required:!0,message:"请选择活动日期",trigger:"change",type:"date"}]},LayoutDialogVisible:!1,EditAble:!1,SaveLoading:!1,SelectRow:{},AuditDialogVisible:!1,AuditLoading:!1,AuditForm:{Status:"",Reason:"",AuditorName:sessionStorage.loginName,rw:""},AuditRules:{Status:[{required:!0,message:"请选择审核结果",trigger:"change"}]},AuditStatusStore:[{label:"审核",id:"A"},{label:"驳回",id:"B"}],winFlag:0}},methods:{ComputedStDate:function(){this.LayoutForm.EndDate&&this.LayoutForm.StDate&&this.LayoutForm.StDate.getTime()>this.LayoutForm.EndDate.getTime()&&(this.$message({message:"开始日期不能大于结束日期!",type:"error",showClose:!0,customClass:"warning_class"}),this.LayoutForm.StDate="")},LoadRoleGroup:function(){var t=this;this.GroupStore=[];var e=this.axiosConfig("web.INMSpecialComm","FindRoleGroupList","RecQuery","nurseid$"+sessionStorage.loginID);this.$ajax.request(e).then(function(e){e.data instanceof Object?t.GroupStore=e.data.rows:t.$message({type:"error",message:"获取权限专业组失败",showClose:!0,customClass:"error_class"})}).catch(function(e){t.$message({type:"error",message:"获取权限专业组失败",showClose:!0,customClass:"error_class"})})},LoadLayoutTable:function(){var t=this,e=(this.CurrentPage-1)*this.PageSize,a=this.PageSize,o=this.ToolForm.Group,i="";this.ToolForm.StDate instanceof Date&&(i=this.ToolForm.StDate.Format("YYYY-MM-dd"));var s="";this.ToolForm.EndDate instanceof Date&&(s=this.ToolForm.EndDate.Format("YYYY-MM-dd"));var l=o+"^"+i+"^"+s+"^"+this.ToolForm.Status;this.LayoutTable=[],this.TableDataAll=[],this.SelectRow={};var n=this.axiosConfig("web.INMSpecialComm","FindLayoutList","RecQuery","parr$"+l,"nurseid$"+sessionStorage.loginID);this.$ajax.request(n).then(function(o){o.data instanceof Object?(t.LayoutTable=o.data.rows.slice(e,e+a),t.TableDataAll=o.data.rows,t.TotalCount=parseInt(o.data.results)):t.$message({type:"error",message:"获取发展规划列表失败",showClose:!0,customClass:"error_class"})}).catch(function(e){t.$message({type:"error",message:"获取发展规划列表失败",showClose:!0,customClass:"error_class"})})},AddClick:function(){var t=this;this.winFlag=0,this.EditAble=!0,this.LayoutForm.rw="",this.LayoutDialogVisible=!0,this.$nextTick(function(){t.$refs.LayoutForm.resetFields()})},Save:function(t){var e=this;this.$refs.LayoutForm.validate(function(a){if(a){var o=e.LayoutForm.Group,i=e.LayoutForm.Year,s="";e.LayoutForm.StDate instanceof Date&&(s=e.LayoutForm.StDate.Format("YYYY-MM-dd"));var l="";e.LayoutForm.EndDate instanceof Date&&(l=e.LayoutForm.EndDate.Format("YYYY-MM-dd"));var n=e.LayoutForm.Content.replace(/\"/g,"☼"),r=o+"^"+i+"^"+s+"^"+l+"^"+t+"^"+e.LayoutForm.rw;e.SaveLoading=!0;var u=e.axiosConfig("web.INMSpecialComm","SaveLayout","LongMethod","parr$"+r,"content$"+n,"nurseid$"+sessionStorage.loginID);e.$ajax.request(u).then(function(t){e.SaveLoading=!1,1==t.data?(e.LayoutDialogVisible=!1,e.$message({type:"success",message:"保存成功",showClose:!0,customClass:"success_class"}),e.LoadLayoutTable()):e.$message({type:"error",message:"保存失败",showClose:!0,customClass:"error_class"})}).catch(function(t){e.SaveLoading=!1,e.$message({type:"error",message:"保存失败",showClose:!0,customClass:"error_class"})})}})},EditClick:function(){var t=this;this.winFlag=1,this.SelectRow&&this.SelectRow.rw?(this.EditAble=!1,this.LayoutForm.rw="",this.LayoutDialogVisible=!0,this.$nextTick(function(){t.$refs.LayoutForm.resetFields(),t.LoadLayoutForm()})):this.$message({type:"warning",message:"请先选中一行数据",showClose:!0,customClass:"warning_class"})},LoadLayoutForm:function(){var t=this;this.SaveLoading=!0;var e=this.axiosConfig("web.INMSpecialComm","GetLayout","Method","id$"+this.SelectRow.rw,"flag$1");this.$ajax.request(e).then(function(e){t.SaveLoading=!1,e.data instanceof Object?("N"!=e.data.LayoutStatus&&"B"!=e.data.LayoutStatus||e.data.Creator!=sessionStorage.loginID&&0!=sessionStorage.loginID?t.EditAble=!1:t.EditAble=!0,t.LayoutForm.Group=e.data.LayoutGroup,t.LayoutForm.Year=parseInt(e.data.LayoutYear),t.LayoutForm.StDate=e.data.LayoutStDate?new Date(e.data.LayoutStDate):"",t.LayoutForm.EndDate=e.data.LayoutEndDate?new Date(e.data.LayoutEndDate):"",t.LayoutForm.Content=e.data.LayoutContent.replace(/☼/g,"'"),t.LayoutForm.rw=e.data.rw):(t.LayoutDialogVisible=!1,t.$message({type:"error",message:"获取发展规划内容失败",showClose:!0,customClass:"error_class"}))}).catch(function(e){t.SaveLoading=!1,t.LayoutDialogVisible=!1,t.$message({type:"error",message:"获取发展规划内容失败",showClose:!0,customClass:"error_class"})})},AuditClick:function(){var t=this;this.SelectRow&&this.SelectRow.rw?"Y"==this.SelectRow.LayoutStatus?(this.AuditDialogVisible=!0,this.$nextTick(function(){t.$refs.AuditForm.resetFields(),t.AuditForm.rw=t.SelectRow.rw})):this.$message({type:"warning",message:this.SelectRow.LayoutStatusDesc+"状态不可审核",showClose:!0,customClass:"warning_class"}):this.$message({type:"warning",message:"请先选中一行数据",showClose:!0,customClass:"warning_class"})},AuditSpecial:function(){var t=this;this.$refs.AuditForm.validate(function(e){if(e){var a=t.AuditForm.Status+"^"+t.AuditForm.Reason+"^"+t.AuditForm.rw;t.AuditLoading=!0;var o=t.axiosConfig("web.INMSpecialComm","AuditLayout","Method","parr$"+a,"nurseid$"+sessionStorage.loginID);t.$ajax.request(o).then(function(e){t.AuditLoading=!1,1==e.data?(t.AuditDialogVisible=!1,t.$message({type:"success",message:"操作成功",showClose:!0,customClass:"success_class"}),t.LoadLayoutTable()):t.$message({type:"error",message:"操作失败",showClose:!0,customClass:"error_class"})}).catch(function(e){t.AuditLoading=!1,t.$message({type:"error",message:"操作失败",showClose:!0,customClass:"error_class"})})}})},DeleteClick:function(){var t=this;this.SelectRow&&this.SelectRow.rw?"N"==this.SelectRow.LayoutStatus||"B"==this.SelectRow.LayoutStatus?this.SelectRow.Creator==sessionStorage.loginID||0==sessionStorage.loginID?this.$confirm("此操作将删除该记录, 是否继续?","提示",{confirmButtonText:"确定",cancelButtonText:"关闭",closeOnClickModal:!1,type:"warning"}).then(function(){var e=t.axiosConfig("web.INMSpecialComm","DeleteLayout","Method","id$"+t.SelectRow.rw);t.$ajax.request(e).then(function(e){1==e.data?(t.$message({message:"删除成功",type:"success",showClose:!0,customClass:"success_class"}),t.LoadLayoutTable()):t.$message({message:"删除失败",type:"error",showClose:!0,customClass:"error_class"})}).catch(function(e){t.$message({message:"删除失败",type:"error",showClose:!0,customClass:"error_class"})})}).catch(function(){t.$message({type:"info",message:"取消删除",showClose:!0,customClass:"info_class"})}):this.$message({type:"warning",message:"非创建人不可删除",showClose:!0,customClass:"warning_class"}):this.$message({type:"warning",message:this.SelectRow.LayoutStatusDesc+"状态不可删除",showClose:!0,customClass:"warning_class"}):this.$message({type:"warning",message:"请先选中一行数据",showClose:!0,customClass:"warning_class"})},RowClickEvent:function(t,e,a){this.SelectRow=t},HandleSizeChange:function(t){this.Pagesize=t,this.LoadLayoutTable()},HandleCurrentChange:function(t){this.CurrentPage=t.currentPage,this.LoadLayoutTable()}},created:function(){this.LoadRoleGroup(),this.LoadLayoutTable();var t=this.$router.currentRoute.path.slice(1,this.$router.currentRoute.path.length);this.loadElementsForRouter("elementlist",t)}},m={render:function(){var t=this,e=t.$createElement,a=t._self._c||e;return a("div",{staticClass:"special-layout-panel"},[a("div",{staticClass:"top-tool-inputDiv"},[a("el-form",{attrs:{inline:!0,model:t.ToolForm,"label-position":"left"}},[a("el-form-item",{attrs:{label:t.$t("menu.SpecialLayout.5nrnc1egzg40")}},[a("el-select",{staticStyle:{width:"120px"},attrs:{filterable:"",clearable:"",placeholder:"",size:"mini"},model:{value:t.ToolForm.Group,callback:function(e){t.$set(t.ToolForm,"Group",e)},expression:"ToolForm.Group"}},t._l(t.GroupStore,function(t){return a("el-option",{key:t.SubValue,attrs:{label:t.SubDesc,value:t.SubValue}})}),1)],1),t._v(" "),a("el-form-item",{attrs:{label:t.$t("menu.SpecialLayout.5nrnc1ei15o0")}},[a("el-date-picker",{staticStyle:{width:"120px"},attrs:{type:"date",format:this.$store.state.mainframe.DateFormat,size:"mini"},model:{value:t.ToolForm.StDate,callback:function(e){t.$set(t.ToolForm,"StDate",e)},expression:"ToolForm.StDate"}})],1),t._v(" "),a("el-form-item",{attrs:{label:t.$t("menu.SpecialLayout.5nrnc1ej18s0")}},[a("el-date-picker",{staticStyle:{width:"120px"},attrs:{type:"date",format:this.$store.state.mainframe.DateFormat,size:"mini"},model:{value:t.ToolForm.EndDate,callback:function(e){t.$set(t.ToolForm,"EndDate",e)},expression:"ToolForm.EndDate"}})],1),t._v(" "),a("el-form-item",{attrs:{label:t.$t("menu.SpecialLayout.5nrnc1ek2go0")}},[a("el-select",{staticStyle:{width:"80px"},attrs:{filterable:"",clearable:"",placeholder:"",size:"mini"},model:{value:t.ToolForm.Status,callback:function(e){t.$set(t.ToolForm,"Status",e)},expression:"ToolForm.Status"}},t._l(t.StatusStore,function(t){return a("el-option",{key:t.value,attrs:{label:t.label,value:t.value}})}),1)],1),t._v(" "),a("el-form-item",[a("hgbutton",{attrs:{type:"default",styleCode:t.styleCode,icon:"nm-icon-w-find",size:"mini"},on:{click:t.LoadLayoutTable}},[t._v(t._s(t.$t("menu.SpecialLayout.5nrnc1ek49k0")))])],1)],1)],1),t._v(" "),a("div",{staticClass:"top-tool-button"},[0==this.$store.state.login.LoginId||t.elementlist.layoutadd?a("hgbutton",{attrs:{type:"text",issvg:t.styleCode,icon:t.styleCode?"#nm-icon-add":"nm-icon-lite-add"},on:{click:t.AddClick}},[t._v(t._s(t.$t("menu.SpecialLayout.5nrnc1ek4zg0")))]):t._e(),t._v(" "),0==this.$store.state.login.LoginId||t.elementlist.layoutdelete?a("hgbutton",{attrs:{type:"text",issvg:t.styleCode,icon:t.styleCode?"#nm-icon-cancel":"nm-icon-lite-cancel"},on:{click:t.DeleteClick}},[t._v(t._s(t.$t("menu.SpecialLayout.5nrnc1ek5c80")))]):t._e(),t._v(" "),0==this.$store.state.login.LoginId||t.elementlist.layoutaudit?a("hgbutton",{attrs:{type:"text",issvg:t.styleCode,icon:t.styleCode?"#nm-icon-stamp":"nm-icon-lite-stamp"},on:{click:t.AuditClick}},[t._v(t._s(t.$t("menu.SpecialLayout.5nrnc1ek5n80")))]):t._e(),t._v(" "),a("hgbutton",{attrs:{type:"text",issvg:t.styleCode,icon:t.styleCode?"#nm-icon-export":"nm-icon-lite-export"},on:{click:function(e){t.exportData("LayoutTable",t.TableDataAll,t.$t("menu.SpecialLayout.5nrnc1el7cc0"))}}},[t._v(t._s(t.$t("menu.SpecialLayout.5nrnc1en6pw0")))])],1),t._v(" "),a("div",{staticClass:"top-tool-table"},[a("el-table",{ref:"LayoutTable",staticStyle:{width:"100%"},attrs:{data:t.LayoutTable,"header-cell-style":t.headerCellFontWeight,"highlight-current-row":!0,border:t.styleCode,height:t.styleCode?t.Height-130:t.Height-124},on:{"row-click":t.RowClickEvent,"row-dblclick":t.EditClick}},[a("el-table-column",{attrs:{type:"index",align:"center",width:"40"}}),t._v(" "),a("el-table-column",{attrs:{label:t.$t("menu.SpecialLayout.5nrnc1ek2go0"),prop:"LayoutStatusDesc","show-overflow-tooltip":"",width:"80",align:"left"}}),t._v(" "),a("el-table-column",{attrs:{label:t.$t("menu.SpecialLayout.5nrnc1egzg40"),prop:"LayoutGroupDesc","show-overflow-tooltip":"",align:"left"}}),t._v(" "),a("el-table-column",{attrs:{label:t.$t("menu.SpecialLayout.5nrnc1eslrk0"),prop:"LayoutYear","show-overflow-tooltip":"",width:"80",align:"left"}}),t._v(" "),a("el-table-column",{attrs:{label:t.$t("menu.SpecialLayout.5nrnc1ei15o0"),prop:"LayoutStDate","show-overflow-tooltip":"",formatter:t.PTableDateHisShow,align:"left"}}),t._v(" "),a("el-table-column",{attrs:{label:t.$t("menu.SpecialLayout.5nrnc1ej18s0"),prop:"LayoutEndDate","show-overflow-tooltip":"",formatter:t.PTableDateHisShow,align:"left"}}),t._v(" "),a("el-table-column",{attrs:{label:t.$t("menu.SpecialLayout.5nrnc1ewjqo0"),prop:"CreatorName","show-overflow-tooltip":"",width:"100",align:"left"}}),t._v(" "),a("el-table-column",{attrs:{label:t.$t("menu.SpecialLayout.5nrnc1exlz80"),prop:"CreateDate","show-overflow-tooltip":"",width:"100",formatter:t.PTableDateHisShow,align:"left"}})],1),t._v(" "),a("hgpagination",{attrs:{styleCode:t.styleCode,sizes:[20,40,50,100],totalCount:t.TotalCount,pageNumber:t.CurrentPage,pageSize:t.PageSize},on:{changePage:t.HandleCurrentChange,getPageSize:t.HandleSizeChange}})],1),t._v(" "),a("el-dialog",{attrs:{title:0==t.winFlag?t.$t("menu.SpecialLayout.5nrnc1ek4zg0"):t.$t("menu.SpecialLayout.5nrnc1ek4zg1"),visible:t.LayoutDialogVisible,"close-on-click-modal":!1,width:"600px"},on:{"update:visible":function(e){t.LayoutDialogVisible=e}}},[a("div",{staticClass:"dialog-header-title",attrs:{slot:"title"},slot:"title"},[t.styleCode?a("i",{class:[0==t.winFlag?"nm-icon-w-plus":"nm-icon-w-edit"]}):t._e(),t._v(" "),0==t.winFlag?a("span",[t._v(t._s(t.$t("menu.SpecialLayout.5nrnc1ek4zg0")))]):1==t.winFlag?a("span",[t._v(t._s(t.$t("menu.SpecialLayout.5nrnc1ek4zg1")))]):t._e()]),t._v(" "),a("div",{directives:[{name:"loading",rawName:"v-loading",value:t.SaveLoading,expression:"SaveLoading"}],attrs:{"element-loading-text":t.$t("menu.SpecialLayout.5nrnc1ezuzg0")}},[a("el-form",{ref:"LayoutForm",attrs:{model:t.LayoutForm,rules:t.Rules,disabled:!t.EditAble,inline:!0,"label-position":"right","label-width":"100px",align:"left"}},[a("el-form-item",{attrs:{label:t.$t("menu.SpecialLayout.5nrnc1egzg40"),prop:"Group"}},[a("el-select",{staticStyle:{width:"160px"},attrs:{filterable:"",clearable:"",placeholder:"",size:"mini"},model:{value:t.LayoutForm.Group,callback:function(e){t.$set(t.LayoutForm,"Group",e)},expression:"LayoutForm.Group"}},t._l(t.GroupStore,function(t){return a("el-option",{key:t.SubValue,attrs:{label:t.SubDesc,value:t.SubValue}})}),1)],1),t._v(" "),a("el-form-item",{attrs:{label:t.$t("menu.SpecialLayout.5nrnc1eslrk0"),prop:"Year"}},[a("el-input-number",{staticStyle:{width:"160px"},attrs:{min:0,placeholder:t.$t("menu.SpecialLayout.5nrnc1f2x740"),"controls-position":"right",size:"mini"},model:{value:t.LayoutForm.Year,callback:function(e){t.$set(t.LayoutForm,"Year",e)},expression:"LayoutForm.Year"}}),a("span",{staticStyle:{display:"inline-block","margin-left":"10px"}},[t._v(t._s(t.$t("menu.SpecialLayout.5nrnc1f2yuo0")))])],1),t._v(" "),a("el-form-item",{attrs:{label:t.$t("menu.SpecialLayout.5nrnc1ei15o0"),prop:"StDate"}},[a("el-date-picker",{staticStyle:{width:"160px"},attrs:{type:"date",format:this.$store.state.mainframe.DateFormat,size:"mini"},on:{change:t.ComputedStDate},model:{value:t.LayoutForm.StDate,callback:function(e){t.$set(t.LayoutForm,"StDate",e)},expression:"LayoutForm.StDate"}})],1),t._v(" "),a("el-form-item",{attrs:{label:t.$t("menu.SpecialLayout.5nrnc1ej18s0"),prop:"EndDate"}},[a("el-date-picker",{staticStyle:{width:"160px"},attrs:{type:"date",format:this.$store.state.mainframe.DateFormat,size:"mini"},on:{change:t.ComputedStDate},model:{value:t.LayoutForm.EndDate,callback:function(e){t.$set(t.LayoutForm,"EndDate",e)},expression:"LayoutForm.EndDate"}})],1),t._v(" "),a("el-form-item",{staticStyle:{"margin-top":"5px"},attrs:{label:t.$t("menu.SpecialLayout.5nrnc1el7cc0"),prop:"Content"}},[a("tinymce",{staticStyle:{width:"456px"},attrs:{disabled:!t.EditAble},model:{value:t.LayoutForm.Content,callback:function(e){t.$set(t.LayoutForm,"Content",e)},expression:"LayoutForm.Content"}})],1)],1),t._v(" "),a("div",{staticClass:"bottom-button"},[a("hgbutton",{attrs:{type:t.styleCode?"default":"success",styleCode:t.styleCode,disabled:!t.EditAble},on:{click:function(e){return t.Save("N")}}},[t._v(t._s(t.$t("menu.SpecialLayout.5nrnc1f8nxw0")))]),t._v(" "),a("hgbutton",{attrs:{type:"default",styleCode:t.styleCode,disabled:!t.EditAble},on:{click:function(e){return t.Save("Y")}}},[t._v(t._s(t.$t("menu.SpecialLayout.5nrnc1f8okw0")))]),t._v(" "),a("hgbutton",{attrs:{type:"default",styleCode:t.styleCode},on:{click:function(e){t.LayoutDialogVisible=!1}}},[t._v(t._s(t.$t("menu.SpecialLayout.5nrnc1f8ovk0")))])],1)],1)]),t._v(" "),a("el-dialog",{attrs:{title:t.$t("menu.SpecialLayout.5nrnc1ek5n80"),visible:t.AuditDialogVisible,"close-on-click-modal":!1,width:"644px"},on:{"update:visible":function(e){t.AuditDialogVisible=e}}},[a("div",{staticClass:"dialog-header-title",attrs:{slot:"title"},slot:"title"},[t.styleCode?a("i",{staticClass:"nm-icon-w-paper"}):t._e(),t._v(" "),a("span",[t._v(t._s(t.$t("menu.SpecialLayout.5nrnc1ek5n80")))])]),t._v(" "),a("div",{directives:[{name:"loading",rawName:"v-loading",value:t.AuditLoading,expression:"AuditLoading"}],attrs:{"element-loading-text":t.$t("menu.SpecialLayout.5nrnc1ezuzg0")}},[a("el-form",{ref:"AuditForm",attrs:{model:t.AuditForm,rules:t.AuditRules,inline:"","label-position":"right","label-width":"100px",align:"left"}},[a("el-form-item",{attrs:{label:t.$t("menu.SpecialLayout.5nrnc1fczps0"),prop:"Status"}},[a("el-select",{staticStyle:{width:"500px"},attrs:{placeholder:"",size:"mini"},model:{value:t.AuditForm.Status,callback:function(e){t.$set(t.AuditForm,"Status",e)},expression:"AuditForm.Status"}},t._l(t.AuditStatusStore,function(t){return a("el-option",{key:t.id,attrs:{value:t.id,label:t.label}})}),1)],1),t._v(" "),a("el-form-item",{staticStyle:{"margin-bottom":"16px"},attrs:{label:t.$t("menu.SpecialLayout.5nrnc1fegq80"),prop:"Reason"}},[a("el-input",{staticStyle:{width:"500px","margin-top":"5px"},attrs:{type:"textarea",placeholder:"",rows:3,maxlength:"200","show-word-limit":"",size:"mini"},model:{value:t.AuditForm.Reason,callback:function(e){t.$set(t.AuditForm,"Reason",e)},expression:"AuditForm.Reason"}})],1),t._v(" "),a("el-form-item",{attrs:{label:t.$t("menu.SpecialLayout.5nrnc1ffh040"),prop:"AuditorName"}},[a("el-input",{staticStyle:{width:"150px"},attrs:{disabled:"",placeholder:"",size:"mini"},model:{value:t.AuditForm.AuditorName,callback:function(e){t.$set(t.AuditForm,"AuditorName",e)},expression:"AuditForm.AuditorName"}})],1),t._v(" "),a("el-form-item",{attrs:{label:t.$t("menu.SpecialLayout.5nrnc1fhe4g0")}},[a("el-input",{staticStyle:{width:"130px"},attrs:{value:(new Date).Format(this.$store.state.mainframe.DateFormat),disabled:"",placeholder:"",size:"mini"}})],1),t._v(" "),a("el-form-item",[a("el-input",{staticStyle:{width:"100px"},attrs:{value:(new Date).Format("hh:mm"),disabled:"",placeholder:"",size:"mini"}})],1)],1),t._v(" "),a("div",{staticClass:"bottom-button"},[a("hgbutton",{attrs:{type:"default",styleCode:t.styleCode},on:{click:t.AuditSpecial}},[t._v(t._s(t.$t("menu.SpecialLayout.5nrnc1f8okw0")))]),t._v(" "),a("hgbutton",{attrs:{type:"default",styleCode:t.styleCode},on:{click:function(e){t.AuditDialogVisible=!1}}},[t._v(t._s(t.$t("menu.SpecialLayout.5nrnc1f8ovk0")))])],1)],1)])],1)},staticRenderFns:[]};var d=a("VU/8")(c,m,!1,function(t){a("ePFl")},null,null);e.default=d.exports}});