webpackJsonp([279],{"+TgP":function(e,t){},Rmtp:function(e,t,s){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var a=s("Dd8w"),n=s.n(a),r=s("NYxO"),o=s("XlQt"),i=s("doZQ"),l={components:{hgbutton:o.default,hgswitch:i.default},computed:n()({},Object(r.b)(["Height","LoginId","DateFormat","styleCode"])),name:"PartTimeApply",data:function(){var e=this;return{searchForm:{PTLoc:"",StDate:(new Date).getWeekDate(1).addDate(0),EndDate:(new Date).getWeekDate(1).addDate(6)},sysArgType:"Week",pickerOptions:{disabledDate:function(t){return"Week"==e.sysArgType?1!=t.getDay():1!=t.getDate()}},locStore:[],tableHead:[],tableData:[],elementlist:[],row:"",column:"",menuShow:!0,detail:!1,dialogVisibleAbsence:!1,AbsenceForm:{Nurse:"",Remark:"",IsOnPost:"否"},nurseStore:[],AbsenceFormRules:{Nurse:[{required:"true",message:"确认人员不能为空",trigger:"change"}]}}},created:function(){var e=this;e.LoadPTLoc();var t=e.$router.currentRoute.path.slice(1,e.$router.currentRoute.path.length);e.$nextTick(function(){e.loadElementsForRouter("elementlist",t)})},mounted:function(){document.addEventListener("click",function(e){if("right-menu"!=e.target.className){var t=document.getElementsByClassName("right-menu");t&&t[0]&&t[0].style&&(t[0].style.display="none")}})},methods:{StDateChange:function(){var e=this;this.searchForm.EndDate=this.searchForm.StDate.addDate(6),"Week"==this.sysArgType?this.searchForm.EndDate=this.searchForm.StDate.addDate(6):this.searchForm.EndDate=this.searchForm.StDate.getMonthLastDate(),e.$nextTick(function(){e.Search()})},Search:function(e){var t=this;e&&(t.searchForm.StDate="Last"==e?t.searchForm.StDate.addDate(-7):"Next"==e?t.searchForm.StDate.addDate(7):(new Date).getWeekDate(1).addDate(0)),t.searchForm.EndDate=t.searchForm.StDate.addDate(6);var s=t.searchForm.StDate.Format("YYYY-MM-dd");t.GetTableHead(),t.tableData=[],t.$ajax.request(t.axiosConfig("web.INMPersonComm","FindPartTimeApplyDetail","RecQuery","loc$"+t.searchForm.PTLoc,"stdate$"+s)).then(function(e){t.tableData=e.data.rows})},LoadPTLoc:function(){var e=this;e.$ajax.request(e.axiosConfig("web.INMPersonComm","FindPartTimeLocList","RecQuery","parr$","nurseid$"+e.LoginId)).then(function(t){e.locStore=t.data.rows,e.searchForm.PTLoc=t.data.rows[0].RowID,e.Search()})},GetTableHead:function(){var e=this.searchForm.StDate;this.tableHead=[{prop:"PTPost",label:"兼职岗位",width:""}];for(var t="",s="",a=0;a<=6;a++)s=(t=e.getWeekDate(1).addDate(a).Format("YYYY-MM-dd"))+"("+e.getWeekDate(1).addDate(a).getWeek()+")",this.tableHead.push({prop:"Date"+t,label:s,width:180});this.tableHead.push({prop:"Remark",label:"备注",width:"150"})},Operate:function(e){var t=this,s=t.row.PostDr,a=t.searchForm.PTLoc,n=t.column.property.split("Date")[1];"Do"==e||"Cancel"==e?t.$ajax.request(t.axiosConfig("web.INMPersonComm","ClaimPost","Method","flag$"+e,"loc$"+a,"post$"+s,"date$"+n,"nurseid$"+t.LoginId)).then(function(e){if(e.data.length<100){var s=-1==e.data.indexOf("成功")?"warning":"success";t.$message({type:s,message:e.data,showClose:!0,customClass:s+"_class"})}else t.$message({type:"error",message:"后端方法报错了，请联系开发^_^",showClose:!0,customClass:"error_class"})}):"Sign"==e&&(t.dialogVisibleAbsence=!0,t.$nextTick(function(){t.$refs.AbsenceForm.resetFields(),t.LoadClaimNurse()}))},CellContextMenu:function(e,t,s,a){if(a.preventDefault(),s.cellIndex>0){if("#FFFFFF"==e[t.property].split("「")[2]||"#AAE3A2"==e[t.property].split("「")[2])this.menuShow=!0;else{if("#C6C6C6"!=e[t.property].split("「")[2])return"#C5C6C6"==e[t.property].split("「")[2]?void this.$message({type:"warning",message:"最早提前两周开放",showClose:!0,customClass:"warning_class"}):void this.$message({type:"warning",message:"不在认领周期内",showClose:!0,customClass:"warning_class"});this.menuShow=!1}this.row=e,this.column=t;var n=document.getElementsByClassName("right-menu");if(n[0]){a.returnValue=!1,a.cancelBubble=!0;var r=a.clientX,o=a.clientY;o+200>document.documentElement.clientHeight&&(o-=200),n[0].style.left=r-1+"px",n[0].style.top=o+"px",n[0].style.display="block"}}},SaveRemark:function(e,t){var s=this,a=s.searchForm.PTLoc,n=s.searchForm.StDate.Format("YYYY-MM-dd");s.$ajax.request(s.axiosConfig("web.INMPersonComm","SaveRowRemark","Method","loc$"+a,"post$"+e,"date$"+n,"remark$"+t,"nurseid$"+s.LoginId)).then(function(e){"1"==e.data?(s.$message({type:"success",message:"保存成功",showClose:!0,customClass:"success_class"}),s.Search()):s.$message({type:"error",message:e.data,showClose:!0,customClass:"error_class"})})},LoadClaimNurse:function(){var e=this,t=e.row.PostDr,s=e.searchForm.PTLoc,a=e.column.property.split("Date")[1];e.$ajax.request(e.axiosConfig("web.INMPersonComm","FindClaimNurseList","RecQuery","loc$"+s,"post$"+t,"date$"+a)).then(function(t){e.nurseStore=t.data.rows})},SaveAbsenceForm:function(){var e=this;this.$refs.AbsenceForm.validate(function(t){if(t){var s=e.AbsenceForm.Remark;e.$ajax.request(e.axiosConfig("web.INMPersonComm","SaveAbsenceForm","Method","remark$"+s,"id$"+e.AbsenceForm.Nurse)).then(function(t){e.dialogVisibleAbsence=!1,"1"==t.data?(e.$message({type:"success",message:"保存成功",showClose:!0,customClass:"success_class"}),e.Search()):e.$message({type:"error",message:t.data,showClose:!0,customClass:"error_class"})})}})},GetAbsenceInfor:function(e){var t=this;e&&t.$ajax.request(t.axiosConfig("web.INMPersonComm","GetAbsenceInfor","Method","id$"+e)).then(function(e){t.AbsenceForm.Remark=e.data.split("~")[0],t.AbsenceForm.IsOnPost="Y"==e.data.split("~")[1]?"是":"否"})},DeleteAbsence:function(){var e=this;e.AbsenceForm.Nurse?"否"!=e.AbsenceForm.IsOnPost?e.$ajax.request(e.axiosConfig("web.INMPersonComm","DeleteAbsence","Method","id$"+e.AbsenceForm.Nurse)).then(function(t){e.dialogVisibleAbsence=!1,"1"==t.data?(e.$message({type:"success",message:"撤销成功",showClose:!0,customClass:"success_class"}),e.Search()):e.$message({type:"error",message:t.data,showClose:!0,customClass:"error_class"})}):e.$message({type:"warning",message:"未缺勤登记不可撤销",showClose:!0,customClass:"warning_class"}):e.$message({type:"warning",message:"请选择要撤销的人员",showClose:!0,customClass:"warning_class"})}}},c={render:function(){var e=this,t=e.$createElement,s=e._self._c||t;return s("div",{staticClass:"parttimeapply-panel"},[s("div",{staticClass:"top-tool-input"},[s("el-form",{ref:"searchForm",attrs:{model:e.searchForm,inline:!0}},[s("el-form-item",{attrs:{label:e.$t("menu.PartTimeApply.5nrnbhddjk00")}},[s("el-select",{staticStyle:{width:"140px"},attrs:{"default-first-option":"",placeholder:e.$t("menu.PartTimeApply.5nrnbhdeg0g0"),size:"mini"},on:{change:e.Search},model:{value:e.searchForm.PTLoc,callback:function(t){e.$set(e.searchForm,"PTLoc",t)},expression:"searchForm.PTLoc"}},e._l(e.locStore,function(e){return s("el-option",{key:e.RowID,attrs:{label:e.LocDesc,value:e.RowID}})}),1)],1),e._v(" "),s("el-form-item",{attrs:{label:e.$t("menu.PartTimeApply.5nrnbhdffbo0")}},[s("el-date-picker",{staticStyle:{width:"120px"},attrs:{"picker-options":e.pickerOptions,type:"date",format:e.DateFormat,clearable:!1,editable:!1,size:"mini"},on:{change:e.StDateChange},model:{value:e.searchForm.StDate,callback:function(t){e.$set(e.searchForm,"StDate",t)},expression:"searchForm.StDate"}})],1),e._v(" "),s("el-form-item",{attrs:{label:e.$t("menu.PartTimeApply.5nrnbhdgidk0")}},[s("el-date-picker",{staticStyle:{width:"120px"},attrs:{disabled:"",type:"date",format:e.DateFormat,size:"mini"},model:{value:e.searchForm.EndDate,callback:function(t){e.$set(e.searchForm,"EndDate",t)},expression:"searchForm.EndDate"}})],1),e._v(" "),s("hgbutton",{attrs:{type:"default",styleCode:e.styleCode,icon:"nm-icon-to-up"},on:{click:function(t){return e.Search("Last")}}},[e._v(e._s(e.$t("menu.PartTimeApply.5ncy6endeks0")))]),e._v(" "),s("hgbutton",{attrs:{type:"default",styleCode:e.styleCode,icon:"nm-icon-to-down"},on:{click:function(t){return e.Search("Next")}}},[e._v(e._s(e.$t("menu.PartTimeApply.5ncy6endf5c0")))]),e._v(" "),s("hgbutton",{attrs:{type:"default",styleCode:e.styleCode,icon:"nm-icon-w-find"},on:{click:function(t){return e.Search("Now")}}},[e._v(e._s(e.$t("menu.PartTimeApply.5ncy6endfnk0")))]),e._v(" "),s("hgswitch",{attrs:{"active-text":e.$t("menu.PartTimeApply.5ncy6endglk0"),"inactive-text":e.$t("menu.PartTimeApply.5ncy6endgs00")},model:{value:e.detail,callback:function(t){e.detail=t},expression:"detail"}}),e._v(" "),s("el-form-item",{attrs:{"label-width":"0px"}},[s("el-tooltip",{staticClass:"item",staticStyle:{"vertical-align":"middle","margin-left":"10px",color:"#1278B8"},attrs:{effect:"dark","popper-class":"SubTypeTitle",content:e.$t("menu.PartTimeApply.5ncy6endi9s0"),placement:"top"}},[s("i",{staticClass:"el-icon-question",staticStyle:{"font-size":"20px"}})])],1)],1)],1),e._v(" "),s("div",{staticClass:"top-tool-table"},[s("el-table",{attrs:{data:e.tableData,height:e.styleCode?e.Height-59:e.Height-58,border:e.styleCode,"header-cell-style":e.headerCellFontWeight,"highlight-current-row":"",align:"left"},on:{"cell-contextmenu":e.CellContextMenu}},[s("el-table-column",{attrs:{type:"index",width:"40",align:"center"}}),e._v(" "),e._l(e.tableHead,function(t){return s("el-table-column",{key:t.prop,attrs:{label:t.label,prop:t.prop,width:t.width,"class-name":"column-padding"},scopedSlots:e._u([{key:"default",fn:function(a){return["-1"!=t.prop.indexOf("Date")?s("div",{style:"background:"+a.row[t.prop].split("「")[2]},[s("span",{staticStyle:{"white-space":"pre-wrap",height:"100%",padding:"0 10px"}},[s("font",[e._v(e._s(a.row[t.prop].split("「")[0]))]),e._v(" "),e.detail?e._l(a.row[t.prop].split("「")[1].split("」"),function(n,r){return s("font",{key:r},[s("font",{style:"color:"+n.split("~")[1]},[e._v(e._s(n.split("~")[0]))]),e._v(" "),s("font",[e._v(e._s(a.row[t.prop].split("「")[1].split("」").length-1>r?"、":""))])],1)}):e._e()],2)]):"Remark"==t.prop?s("el-input",{staticStyle:{width:"100%"},attrs:{size:"mini",placeholder:e.$t("menu.PartTimeApply.5nrnbhdholw0")},on:{blur:function(s){return e.SaveRemark(a.row.PostDr,a.row[t.prop])}},model:{value:a.row[t.prop],callback:function(s){e.$set(a.row,t.prop,s)},expression:"scope.row[col.prop]"}}):s("span",{staticStyle:{padding:"0 10px"}},[e._v(e._s(a.row[t.prop]))])]}}],null,!0)})})],2)],1),e._v(" "),s("div",[s("el-dialog",{attrs:{title:e.$t("menu.PartTimeApply.5ncy6ene0100"),visible:e.dialogVisibleAbsence,"close-on-click-modal":!1,"custom-class":"el-dialog_tiny"},on:{"update:visible":function(t){e.dialogVisibleAbsence=t}}},[s("div",{staticClass:"dialog-header-title",attrs:{slot:"title"},slot:"title"},[e.styleCode?s("i",{staticClass:"nm-icon-w-paper"}):e._e(),e._v(" "),s("span",[e._v(e._s(e.$t("menu.PartTimeApply.5ncy6ene0100")))])]),e._v(" "),s("el-form",{ref:"AbsenceForm",attrs:{model:e.AbsenceForm,rules:e.AbsenceFormRules,"label-width":"70px","label-position":"right",inline:!0}},[s("el-form-item",{attrs:{label:e.$t("menu.PartTimeApply.5nrnbhdj1ww0"),prop:"Nurse"}},[s("el-select",{attrs:{clearable:"",filterable:"",placeholder:e.$t("menu.PartTimeApply.5nrnbhdeg0g0"),size:"mini"},on:{change:function(t){return e.GetAbsenceInfor(e.AbsenceForm.Nurse)}},model:{value:e.AbsenceForm.Nurse,callback:function(t){e.$set(e.AbsenceForm,"Nurse",t)},expression:"AbsenceForm.Nurse"}},e._l(e.nurseStore,function(e){return s("el-option",{key:e.Id,attrs:{label:e.PerName,value:e.Id}})}),1)],1),e._v(" "),s("el-form-item",{attrs:{label:e.$t("menu.PartTimeApply.5ncy6ene3fw0"),prop:"IsOnPost"}},[s("el-input",{attrs:{disabled:"",size:"mini"},model:{value:e.AbsenceForm.IsOnPost,callback:function(t){e.$set(e.AbsenceForm,"IsOnPost",t)},expression:"AbsenceForm.IsOnPost"}})],1),e._v(" "),s("el-form-item",{attrs:{label:e.$t("menu.PartTimeApply.5nrnbhdkvz00"),prop:"Remark"}},[s("el-input",{attrs:{size:"mini"},model:{value:e.AbsenceForm.Remark,callback:function(t){e.$set(e.AbsenceForm,"Remark",t)},expression:"AbsenceForm.Remark"}})],1)],1),e._v(" "),s("div",{staticClass:"bottom-button"},[s("hgbutton",{directives:[{name:"intervalclick",rawName:"v-intervalclick",value:{func:e.SaveAbsenceForm,time:500},expression:"{func:SaveAbsenceForm,time:500}"}],attrs:{type:e.styleCode?"default":"success",styleCode:e.styleCode}},[e._v(e._s(e.$t("menu.PartTimeApply.5nrnbhdkx9g0")))]),e._v(" "),s("hgbutton",{attrs:{type:"default",styleCode:e.styleCode},on:{click:e.DeleteAbsence}},[e._v(e._s(e.$t("menu.PartTimeApply.5ncy6ene60g0")))]),e._v(" "),s("hgbutton",{attrs:{type:"default",styleCode:e.styleCode},on:{click:function(t){e.dialogVisibleAbsence=!1}}},[e._v(e._s(e.$t("menu.PartTimeApply.5nrnbhdkybg0")))])],1)],1)],1),e._v(" "),s("div",{staticClass:"right-menu",staticStyle:{display:"none",width:"120px",position:"absolute","z-index":"9999"}},[s("ul",[e.menuShow?s("li",{ref:"claim"},[s("a",{staticClass:"right-menu-btn",attrs:{href:"javascript:void(0);"},on:{click:function(t){return e.Operate("Do")}}},[e._v(e._s(e.$t("menu.PartTimeApply.5ncy6ene8ds0")))])]):e._e(),e._v(" "),e.menuShow?s("li",{ref:"cancel"},[s("a",{staticClass:"right-menu-btn",attrs:{href:"javascript:void(0);"},on:{click:function(t){return e.Operate("Cancel")}}},[e._v(e._s(e.$t("menu.PartTimeApply.5nrnbhdkzrk0")))])]):e._e(),e._v(" "),e.menuShow||!this.elementlist.sign&&0!=e.LoginId?e._e():s("li",{ref:"sign"},[s("a",{staticClass:"right-menu-btn",attrs:{href:"javascript:void(0);"},on:{click:function(t){return e.Operate("Sign")}}},[e._v(e._s(e.$t("menu.PartTimeApply.5ncy6ene0100")))])])])])])},staticRenderFns:[]};var m=s("VU/8")(l,c,!1,function(e){s("+TgP")},null,null);t.default=m.exports}});