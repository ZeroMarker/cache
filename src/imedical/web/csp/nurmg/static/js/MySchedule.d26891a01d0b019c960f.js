webpackJsonp([318],{k49Z:function(e,t,a){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var o=a("Dd8w"),l=a.n(o),r=a("NYxO"),s=a("XlQt"),i={name:"MySchedule",computed:l()({},Object(r.b)(["Height","styleCode"])),components:{hgbutton:s.default},data:function(){return{Approval:{totalData:[],dialogVisible:!1,dialogTitle:"",keyID:"",rw:"",tableColumn:[],tableData:[],Selection:"",EditDialogVisible:!1,OptionFlag:!1,AuditStatusStore:[],AuditForm:{Status:"",option:""},AuditRules:{Status:[{required:!0,message:"请选择审批结果",trigger:"change"}]}}}},created:function(){this.Approval.rw=this.$route.query.DealtID,this.Approval.keyID=this.$route.query.KeyID,this.loadApprovalColumn()},methods:{ArrrovalRowClick:function(e){this.$refs.ApprovalTable.toggleRowSelection(e)},ArrrovalSelectChange:function(e){this.Approval.Selection=e},loadApprovalColumn:function(){var e=this;e.Approval.tableColumn=new Array,e.Approval.tableData=new Array,e.Approval.Selection=new Array;var t=e.Approval.rw+"^Y",a=e.axiosConfig("web.INMSetComm","FindApprovalSetShow","RecQuery","parr$"+t);e.$ajax.request(a).then(function(t){t.data instanceof Object?(e.Approval.tableColumn=t.data.rows,e.$nextTick(function(){e.$refs.ApprovalTable.doLayout(),e.loadApprovalTableData()})):e.$message({type:"error",message:"获取审批列头数据失败",showClose:!0,customClass:"error_class"})}).catch(function(t){e.$message({type:"error",message:"获取审批列头数据失败",showClose:!0,customClass:"error_class"})})},loadApprovalTableData:function(){var e=this;e.Approval.tableData=new Array,e.Approval.Selection=new Array;var t=e.Approval.keyID,a=sessionStorage.getItem("loginID"),o=e.axiosConfig("web.INMPlatform","FindApprovalDetailByUser","RecQuery","keyID$"+t,"loginID$"+a);e.$ajax.request(o).then(function(t){t.data instanceof Object?(e.Approval.tableData=t.data.rows,0==e.Approval.tableData.length&&(e.Approval.dialogVisible=!1,e.LoadApproval())):e.$message({type:"error",message:"获取审批数据失败",showClose:!0,customClass:"error_class"})}).catch(function(t){e.$message({type:"error",message:"获取审批数据失败",showClose:!0,customClass:"error_class"})})},LoadApproval:function(){var e=this,t=e.axiosConfig("web.INMPlatform","FindApprovalByUser","RecQuery","loginID$"+sessionStorage.getItem("loginID"),"parr$");e.$ajax.request(t).then(function(t){t.data instanceof Object?e.Approval.totalData=t.data.rows:e.$message({type:"error",message:"获取审批待办失败",showClose:!0,customClass:"error_class"})}).catch(function(t){e.$message({type:"error",message:"获取审批待办方法报错,请联系开发",showClose:!0,customClass:"error_class"})})},ApprovalClick:function(){if(this.Approval.Selection&&0!=this.Approval.Selection.length){var e=this.Approval.Selection[0],t=[{rw:e.ToValue,desc:"通过"}];"Y"==e.BackFlag&&t.push({rw:e.BackToValue,desc:"驳回"}),this.Approval.AuditStatusStore=t,this.Approval.OptionFlag="Y"==e.OptionFlag,this.Approval.EditDialogVisible=!0}else this.$message({type:"warning",message:"请选择要审核的数据记录",showClose:!0,customClass:"warning_class"})},AuditApprovalApp:function(){for(var e=this,t=new Object,a=0;a<this.Approval.AuditStatusStore.length;a++){var o=this.Approval.AuditStatusStore[a];o&&(t[o.rw]=o.desc)}e.$refs.Approval_AuditForm.validate(function(a){if(a){for(var o=e.Approval.keyID,l=e.Approval.AuditForm.Status,r=t[l],s=e.Approval.AuditForm.option,i=sessionStorage.getItem("loginID"),n=new Array,p=0;p<e.Approval.Selection.length;p++){var u=e.Approval.Selection[p];u&&u.rw&&n.push(u.rw)}n=n.toString();var c=e.axiosConfig("web.INMPlatform","SaveApprovalData","Method","rws$"+n,"keyID$"+o,"toValue$"+l,"option$"+s,"toValueDesc$"+r,"loginID$"+i);e.$ajax.request(c).then(function(t){1==t.data?(e.$message({type:"success",message:"操作成功",showClose:!0,customClass:"success_class"}),e.Approval.EditDialogVisible=!1,e.loadApprovalTableData(),e.LoadApproval()):t.data.length<100?e.$message({type:"error",message:t.data,showClose:!0,customClass:"error_class"}):e.$message({type:"error",message:"后台方法出错,请联系开发^_^",showClose:!0,customClass:"error_class"})}).catch(function(t){e.$message({type:"error",message:"方法出错,请联系开发^_^",showClose:!0,customClass:"error_class"})})}})}},watch:{}},n={render:function(){var e=this,t=e.$createElement,a=e._self._c||t;return a("div",[a("div",{staticClass:"top-tool-input"},[a("hgbutton",{attrs:{type:"default",styleCode:e.styleCode},on:{click:e.loadApprovalTableData}},[e._v(e._s(e.$t("menu.MySchedule.5nrnbofu1sc0")))]),e._v(" "),a("hgbutton",{attrs:{type:"default",styleCode:e.styleCode},on:{click:e.ApprovalClick}},[e._v(e._s(e.$t("menu.MySchedule.5nrnbofu2u80")))])],1),e._v(" "),a("div",{attrs:{calss:"top-tool-table"}},[a("el-table",{ref:"ApprovalTable",attrs:{data:e.Approval.tableData,"highlight-current-row":"",border:e.styleCode,height:e.Height-60+"px","header-cell-style":e.headerCellFontWeight},on:{"row-click":e.ArrrovalRowClick,"selection-change":e.ArrrovalSelectChange}},[a("el-table-column",{attrs:{type:"selection",width:"50",align:"center"}}),e._v(" "),e._l(e.Approval.tableColumn,function(e){return a("el-table-column",{key:e.rwProp,attrs:{label:e.ShowDesc,prop:e.rwProp,width:e.ShowWidth,"show-overflow-tooltip":"",align:"center"}})})],2)],1),e._v(" "),a("div",[a("el-dialog",{attrs:{title:e.$t("menu.MySchedule.5nrnbofu2u80"),visible:e.Approval.EditDialogVisible,"close-on-click-modal":!1,width:e.Approval.OptionFlag?"650px":"400px"},on:{"update:visible":function(t){return e.$set(e.Approval,"EditDialogVisible",t)}}},[a("div",{staticClass:"dialog-header-title",attrs:{slot:"title"},slot:"title"},[e.styleCode?a("i",{staticClass:"nm-icon-w-paper"}):e._e(),e._v(" "),a("span",[e._v(e._s(e.$t("menu.MySchedule.5nrnbofu2u80")))])]),e._v(" "),a("el-form",{ref:"Approval_AuditForm",attrs:{model:e.Approval.AuditForm,rules:e.Approval.AuditRules,"label-position":"right","label-width":"80px"}},[a("el-form-item",{attrs:{label:e.$t("menu.MySchedule.5nrnbofu5ug0"),prop:"Status"}},[a("el-select",{attrs:{placeholder:"",size:"mini"},model:{value:e.Approval.AuditForm.Status,callback:function(t){e.$set(e.Approval.AuditForm,"Status",t)},expression:"Approval.AuditForm.Status"}},e._l(e.Approval.AuditStatusStore,function(e){return a("el-option",{key:e.rw,attrs:{value:e.rw,label:e.desc}})}),1)],1),e._v(" "),e.Approval.OptionFlag?a("el-form-item",{attrs:{label:e.$t("menu.MySchedule.5nrnbofu6ko0"),prop:"option"}},[a("el-input",{staticStyle:{width:"100%","margin-top":"10px"},attrs:{type:"textarea",placeholder:"",rows:3,maxlength:"200","show-word-limit":"",size:"mini"},model:{value:e.Approval.AuditForm.option,callback:function(t){e.$set(e.Approval.AuditForm,"option",t)},expression:"Approval.AuditForm.option"}})],1):e._e()],1),e._v(" "),a("div",{staticClass:"bottom-button"},[a("hgbutton",{directives:[{name:"intervalclick",rawName:"v-intervalclick",value:{func:e.AuditApprovalApp,time:500},expression:"{func:AuditApprovalApp,time:500}"}],attrs:{type:"default",styleCode:e.styleCode}},[e._v(e._s(e.$t("menu.MySchedule.5nrnbofu7jk0")))]),e._v(" "),a("hgbutton",{attrs:{type:"default",styleCode:e.styleCode},on:{click:function(t){e.Approval.EditDialogVisible=!1}}},[e._v(e._s(e.$t("menu.MySchedule.5nrnbofu7x00")))])],1)],1)],1)])},staticRenderFns:[]},p=a("VU/8")(i,n,!1,null,null,null);t.default=p.exports}});