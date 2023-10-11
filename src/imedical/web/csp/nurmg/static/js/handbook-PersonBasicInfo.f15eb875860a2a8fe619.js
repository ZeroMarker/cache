webpackJsonp([300],{INsv:function(e,s){},llsR:function(e,s,o){"use strict";Object.defineProperty(s,"__esModule",{value:!0});var t=o("Dd8w"),a=o.n(t),r=o("NYxO"),n=o("XlQt"),i=o("W5Fe"),l={name:"PersonBasicInfo",computed:a()({},Object(r.b)(["Height","styleCode"])),props:{},components:{Hgbutton:n.default,hgpagination:i.default},data:function(){return{ToolForm:{Ward:""},Rules:{Ward:[{required:!0,message:"请选择病区",trigger:"change"}]},WardStore:[],HireDutyStore:[],PersonHireDuty:{},LevelStore:[],PersonLevel:{},AcademicStore:[],PersonAcademic:{},PersonTable:[],CurrentPage:1,PageSize:20,TotalCount:0,PersonTableHead:[]}},methods:{LoadRoleWard:function(){var e=this,s=this.axiosConfig("web.INMDataLimit","FindRoleWardList","RecQuery","nurseid$"+sessionStorage.loginID);this.$ajax.request(s).then(function(s){s.data instanceof Object?(e.WardStore=s.data.rows,e.WardStore.length>0&&(e.ToolForm.Ward=e.WardStore[0].rw,e.ToolFormSearch())):e.$message({type:"error",message:"获取权限病区失败",showClose:!0,customClass:"error_class"})}).catch(function(s){e.$message({type:"error",message:"获取权限病区失败",showClose:!0,customClass:"error_class"})})},LoadTableHead:function(){var e=this;this.PersonTableHead=[];var s=this.axiosConfig("web.INMFieldSetComm","FindSortFields","RecQuery","menu$personlist");this.$ajax.request(s).then(function(s){s.data instanceof Object?(e.PersonTableHead=s.data.rows,e.$nextTick(function(){e.$refs.PersonTable.doLayout()})):e.$message({type:"error",message:"获取表头失败",showClose:!0,customClass:"error_class"})}).catch(function(s){e.$message({type:"error",message:"获取表头失败",showClose:!0,customClass:"error_class"})})},ToolFormSearch:function(){this.LoadWardDutyInfo(),this.LoadWardLevelInfo(),this.LoadWardAcademicInfo(),this.LoadWardPersonInfo()},LoadWardDutyInfo:function(){var e=this,s=(new Date).Format("YYYY-MM-dd")+"!"+this.ToolForm.Ward;this.PersonHireDuty={};var o=this.axiosConfig("web.INMPersonCountComm","FindPersonDistribute","RecQuery","parr$"+s,"type$HireDuty","flag$","loginId$"+sessionStorage.loginRoleCodes,"roles$"+sessionStorage.loginID);this.$ajax.request(o).then(function(s){s.data instanceof Object?e.PersonHireDuty=s.data.rows[0]:e.$message({type:"error",message:"获取人员职称数据失败",showClose:!0,customClass:"error_class"})}).catch(function(s){e.$message({type:"error",message:"获取人员职称数据失败",showClose:!0,customClass:"error_class"})})},LoadWardLevelInfo:function(){var e=this,s=(new Date).Format("YYYY-MM-dd")+"!"+this.ToolForm.Ward;this.PersonLevel={};var o=this.axiosConfig("web.INMPersonCountComm","FindPersonDistribute","RecQuery","parr$"+s,"type$Level","flag$","loginId$"+sessionStorage.loginRoleCodes,"roles$"+sessionStorage.loginID);this.$ajax.request(o).then(function(s){s.data instanceof Object?e.PersonLevel=s.data.rows[0]:e.$message({type:"error",message:"获取人员层级数据失败",showClose:!0,customClass:"error_class"})}).catch(function(s){e.$message({type:"error",message:"获取人员层级数据失败",showClose:!0,customClass:"error_class"})})},LoadWardAcademicInfo:function(){var e=this,s=(new Date).Format("YYYY-MM-dd")+"!"+this.ToolForm.Ward;this.PersonAcademic={};var o=this.axiosConfig("web.INMPersonCountComm","FindPersonDistribute","RecQuery","parr$"+s,"type$Education","flag$","loginId$"+sessionStorage.loginRoleCodes,"roles$"+sessionStorage.loginID);this.$ajax.request(o).then(function(s){s.data instanceof Object?e.PersonAcademic=s.data.rows[0]:e.$message({type:"error",message:"获取人员学历数据失败",showClose:!0,customClass:"error_class"})}).catch(function(s){e.$message({type:"error",message:"获取人员学历数据失败",showClose:!0,customClass:"error_class"})})},LoadWardPersonInfo:function(){var e=this,s=(this.CurrentPage-1)*this.PageSize,o=this.PageSize,t="!"+this.ToolForm.Ward+"!!"+sessionStorage.loginRoleCodes+"!"+sessionStorage.loginID;this.PersonTable=[];var a=this.axiosConfig("web.INMPersonComm","FindPersons","RecQuery","parr$"+t,"start$"+s,"limit$"+o);this.$ajax.request(a).then(function(s){s.data instanceof Object?(e.PersonTable=s.data.rows,e.TotalCount=parseInt(s.data.results)):e.$message({type:"error",message:"获取人员数据列表失败",showClose:!0,customClass:"error_class"})}).catch(function(s){e.$message({type:"error",message:"获取人员数据列表失败",showClose:!0,customClass:"error_class"})})},HandleSizeChange:function(e){this.PageSize=e,this.LoadWardPersonInfo()},HandleCurrentChange:function(e){this.CurrentPage=e.currentPage,this.LoadWardPersonInfo()}},created:function(){this.LoadRoleWard(),this.loadSysParamSubData("聘任职称","HireDutyStore"),this.loadSysParamSubData("护士层级","LevelStore"),this.loadSysParamSubData("学历","AcademicStore"),this.LoadTableHead()}},c={render:function(){var e=this,s=e.$createElement,o=e._self._c||s;return o("div",{staticClass:"per-basic-info-panel"},[o("div",{staticClass:"top-tool-input",style:{"border-bottom":e.styleCode?"1px solid #CFCFCF":"1px solid #e2e2e2"}},[o("el-form",{attrs:{inline:!0,model:e.ToolForm,rules:e.Rules,"label-position":"left"}},[o("el-form-item",{attrs:{label:e.$t("menu.PersonBasicInfo.5nrnb5r2u4w0"),prop:"Ward"}},[o("el-select",{staticStyle:{width:"140px"},attrs:{size:"mini"},on:{change:e.ToolFormSearch},model:{value:e.ToolForm.Ward,callback:function(s){e.$set(e.ToolForm,"Ward",s)},expression:"ToolForm.Ward"}},e._l(e.WardStore,function(e){return o("el-option",{key:e.rw,attrs:{label:e.WardDesc,value:e.rw}})}),1)],1),e._v(" "),o("el-form-item",[o("hgbutton",{attrs:{type:"default",styleCode:e.styleCode,icon:"nm-icon-w-find"},on:{click:e.ToolFormSearch}},[e._v(e._s(e.$t("menu.PersonBasicInfo.5nrnb5r2wk80")))])],1)],1)],1),e._v(" "),o("div",{staticStyle:{padding:"10px",height:"80px"}},[o("div",[o("div",{staticClass:"basic-title"},[e._v(e._s(e.$t("menu.PersonBasicInfo.5ncy68rx1ps0")))]),e._v(" "),e._l(e.HireDutyStore,function(s){return o("div",{key:s.SubValue,staticStyle:{display:"inline-block","font-size":"13px","margin-left":"8px"}},[e._v(e._s(s.SubDesc+" "+(e.PersonHireDuty&&e.PersonHireDuty[s.SubValue.replace("||","__")]?e.PersonHireDuty[s.SubValue.replace("||","__")]:0)))])})],2),e._v(" "),o("div",{staticStyle:{"margin-top":"10px"}},[o("div",{staticClass:"basic-title"},[e._v(e._s(e.$t("menu.PersonBasicInfo.5ncy68rx30w0")))]),e._v(" "),e._l(e.LevelStore,function(s){return o("div",{key:s.SubValue,staticStyle:{display:"inline-block","font-size":"13px","margin-left":"8px"}},[e._v(e._s(s.SubDesc+" "+(e.PersonLevel&&e.PersonLevel[s.SubValue.replace("||","__")]?e.PersonLevel[s.SubValue.replace("||","__")]:0)))])})],2),e._v(" "),o("div",{staticStyle:{"margin-top":"10px"}},[o("div",{staticClass:"basic-title"},[e._v(e._s(e.$t("menu.PersonBasicInfo.5ncy68rx4440")))]),e._v(" "),e._l(e.AcademicStore,function(s){return o("div",{key:s.SubValue,staticStyle:{display:"inline-block","font-size":"13px","margin-left":"8px"}},[e._v(e._s(s.SubDesc+" "+(e.PersonAcademic&&e.PersonAcademic[s.SubValue.replace("||","__")]?e.PersonAcademic[s.SubValue.replace("||","__")]:0)))])})],2)]),e._v(" "),o("div",{staticClass:"top-tool-table"},[o("el-table",{ref:"PersonTable",attrs:{data:e.PersonTable,"highlight-current-row":"","header-cell-style":e.headerCellFontWeight,border:e.styleCode,height:e.styleCode?e.Height-195:e.Height-192}},[o("el-table-column",{attrs:{type:"index",align:"center",width:"40"}}),e._v(" "),e._l(e.PersonTableHead,function(e){return o("el-table-column",{key:e.rowid,attrs:{label:e.desc,prop:e.code,"show-overflow-tooltip":"",width:e.width}})})],2),e._v(" "),o("hgpagination",{attrs:{styleCode:e.styleCode,sizes:[20,40,50,100],totalCount:e.TotalCount,pageNumber:e.CurrentPage,pageSize:e.PageSize},on:{changePage:e.HandleCurrentChange,getPageSize:e.HandleSizeChange}})],1)])},staticRenderFns:[]};var d=o("VU/8")(l,c,!1,function(e){o("INsv")},null,null);s.default=d.exports}});