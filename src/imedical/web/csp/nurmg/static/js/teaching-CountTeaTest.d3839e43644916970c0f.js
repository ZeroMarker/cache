webpackJsonp([306],{Q2H6:function(e,t){},hun7:function(e,t,o){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var a=o("Dd8w"),r=o.n(a),s=o("NYxO"),l=o("zL8q"),n=o("XlQt"),i={name:"CountTeaTest",computed:r()({},Object(s.b)(["Height","styleCode"])),props:{},components:{hgbutton:n.default},data:function(){return{ToolForm:{Year:new Date,ward:""},WardStore:[],TableData:[],CurrentPage:1,PageSize:20,TotalCount:0,columnStore:[]}},methods:{ExportClick:function(){if(this.TableData&&0!=this.TableData.length){for(var e=o("qfDe").create_excel,t=[{label:"月份",prop:"Month",width:100}],a=0;a<this.columnStore.length;a++){var r=this.columnStore[a];if(r){var s=r.SubValue.replace("||","__"),n=r.SubDesc+"(人次)";t.push({prop:s,label:n,width:100})}}var i=new Array,c=t,u=l.Loading.service({fullscreen:!0,text:"拼命加载中..."});e(c,this.TableData,i,"","export","培训汇总","培训汇总","",u)}else this.$message({type:"warning",message:"无数据导出",showClose:!0,customClass:"warning_class"})},LoadRoleWard:function(){var e=this,t=this.axiosConfig("web.INMDataLimit","FindRoleWardList","RecQuery","nurseid$"+sessionStorage.loginID,"parr$");this.$ajax.request(t).then(function(t){t.data instanceof Object?e.WardStore=t.data.rows:e.$message({type:"error",message:"获取权限病区失败",showClose:!0,customClass:"error_class"})}).catch(function(t){e.$message({type:"error",message:"获取权限病区失败",showClose:!0,customClass:"error_class"})})},ToolFormSearch:function(){var e=this,t=(e.CurrentPage,e.PageSize,e.CurrentPage,e.PageSize,e.ToolForm.Year),o=e.ToolForm.ward;if(o=o||"",t=t instanceof Date?t.Format("YYYY"):""){var a=o+"^"+t,r=e.axiosConfig("web.INMTeaComm","FindCountTeaTest","RecQuery","parr$"+a,"loginID$"+sessionStorage.getItem("loginID"));e.$ajax.request(r).then(function(t){t.data instanceof Object?e.TableData=t.data.rows:e.$message({type:"error",message:"获取数据失败",showClose:!0,customClass:"error_class"})}).catch(function(t){e.$message({type:"error",message:"获取数据失败",showClose:!0,customClass:"error_class"})})}else e.$message({type:"error",message:"请选择年份",showClose:!0,customClass:"error_class"})},RowClick:function(e,t,o){},RowDblClick:function(e,t,o){},HandleSizeChange:function(e){this.PageSize=e,this.ToolFormSearch()},HandleCurrentChange:function(e){this.CurrentPage=e,this.ToolFormSearch()}},created:function(){this.LoadRoleWard(),this.loadSysParamSubData("护士培训项目类型","columnStore")}},c={render:function(){var e=this,t=e.$createElement,o=e._self._c||t;return o("div",{staticClass:"count-tea-test-panel"},[o("div",{staticClass:"top-tool-input"},[o("el-form",{attrs:{model:e.ToolForm,inline:!0}},[o("el-form-item",{attrs:{label:e.$t("menu.CountTeaTest.5nrnc7zm6l80")}},[o("el-date-picker",{staticStyle:{width:"120px"},attrs:{clearable:!1,type:"year",placeholder:e.$t("menu.CountTeaTest.5nrnc7znoo00"),size:"mini"},model:{value:e.ToolForm.Year,callback:function(t){e.$set(e.ToolForm,"Year",t)},expression:"ToolForm.Year"}})],1),e._v(" "),o("el-form-item",{attrs:{label:e.$t("menu.CountTeaTest.5nrnc7zov700")}},[o("el-select",{staticStyle:{width:"140px"},attrs:{clearable:"",size:"mini"},model:{value:e.ToolForm.ward,callback:function(t){e.$set(e.ToolForm,"ward",t)},expression:"ToolForm.ward"}},e._l(e.WardStore,function(e){return o("el-option",{key:e.rw,attrs:{label:e.WardDesc,value:e.rw}})}),1)],1),e._v(" "),o("el-form-item",[o("hgbutton",{attrs:{type:"default",styleCode:e.styleCode,icon:"nm-icon-w-find"},on:{click:e.ToolFormSearch}},[e._v(e._s(e.$t("menu.CountTeaTest.5nrnc7zowqg0")))]),e._v(" "),o("hgbutton",{attrs:{type:"default",styleCode:e.styleCode,icon:"nm-icon-export"},on:{click:e.ExportClick}},[e._v(e._s(e.$t("menu.CountTeaTest.5nrnc7zox240")))])],1)],1)],1),e._v(" "),o("div",{staticClass:"top-tool-table"},[o("el-table",{attrs:{data:e.TableData,"header-cell-style":e.headerCellFontWeight,"highlight-current-row":"",border:e.styleCode,height:e.Height-59},on:{"row-click":e.RowClick,"row-dblclick":e.RowDblClick}},[o("el-table-column",{attrs:{label:e.$t("menu.CountTeaTest.5nrnc7zpxsc0"),prop:"Month",align:"left",width:"80","show-overflow-tooltip":""}}),e._v(" "),e._l(e.columnStore,function(t){return o("el-table-column",{key:t.SubValue,attrs:{label:t.SubDesc+e.$t("menu.CountTeaTest.5ncy6upgxcg0"),prop:t.SubValue.replace("||","__"),align:"left","show-overflow-tooltip":""}})})],2)],1)])},staticRenderFns:[]};var u=o("VU/8")(i,c,!1,function(e){o("Q2H6")},null,null);t.default=u.exports}});