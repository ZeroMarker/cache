webpackJsonp([309],{SdR9:function(e,t,i){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var n=i("Dd8w"),o=i.n(n),a=i("NYxO"),s=i("XlQt"),l=i("W5Fe"),r=i("doZQ"),d={components:{hgbutton:s.default,hgpagination:l.default,hgswitch:r.default},computed:o()({},Object(a.b)(["Height","styleCode"])),data:function(){return{currentPage:1,currentPageSize:20,totalCount:0,dialogVisible:!1,labelWidth:"width:170px",finds:{},tableData:[],wardStore:[],editForm:{Code:"",TypeDesc:"",Status:"Y",Remark:"",rw:""},rules:{Code:[{required:!0,message:"请输入编码！",trigger:"blur"}],TypeDesc:[{required:!0,message:"请输入描述！",trigger:"blur"}],Status:[{required:!0,message:"请输选择状态！",trigger:"change"}]},winFlag:0}},created:function(){this.findClick()},methods:{handleCurrentChange:function(e){this.currentPage=e.currentPage,this.findClick()},handleSizeChange:function(e){this.currentPageSize=e,this.findClick()},rowDblclick:function(e){var t=this;if(t.winFlag=1,""!=e.rw){var i=this.axiosConfig("web.NurSensConfigComm","GetSensType","RecMethod","id$"+e.rw);this.$ajax.request(i).then(function(e){t.dialogVisible=!0,t.$nextTick(function(){t.$refs.editForm.resetFields(),t.setForm(t.$refs.editForm,t.editForm,e.data)})}).catch(function(e){})}},findClick:function(){var e=this,t=(this.currentPage-1)*this.currentPageSize,i=this.currentPageSize,n=this.axiosConfig("web.NurSensConfigComm","FindSensTypeList","RecQuery","parr$","start$"+t,"limit$"+i);this.$ajax.request(n).then(function(t){e.tableData=t.data.rows,e.totalCount=parseInt(t.data.results)}).catch(function(e){})},addClick:function(){var e=this;e.winFlag=0,e.dialogVisible=!0,e.$nextTick(function(){e.$refs.editForm.resetFields(),e.editForm.rw=""})},saveClick:function(){var e=this;this.$refs.editForm.validate(function(t){if(!t)return!1;var i="";for(var n in e.editForm)void 0==e.editForm[n]&&(e.editForm[n]=""),i=e.editForm[n]instanceof Date?i+n+"|"+e.editForm[n].Format("yyyy-MM-dd")+"^":i+n+"|"+e.editForm[n].toString()+"^";if(""!=i){var o=e.axiosConfig("web.NurSensConfigComm","SaveSensType","Method","parr$"+i);e.$ajax.request(o).then(function(t){1==t.data?(e.$message({message:"保存成功！",type:"success",showClose:!0,customClass:"success_class"}),e.dialogVisible=!1,e.findClick()):e.$message({type:"warning",message:t.data,showClose:!0,customClass:"warning_class"})}).catch(function(t){e.$message({type:"warning",message:"保存失败！",showClose:!0,customClass:"warning_class"})})}})}}},c={render:function(){var e=this,t=e.$createElement,i=e._self._c||t;return i("div",[i("div",{staticClass:"top-tool-button"},[i("hgbutton",{attrs:{type:"text",issvg:e.styleCode,icon:e.styleCode?"#nm-icon-add":"nm-icon-lite-add"},on:{click:e.addClick}},[e._v(e._s(e.$t("menu.IndexTypeSet.5nrnbyijr880")))])],1),e._v(" "),i("div",{staticClass:"top-tool-table"},[i("el-table",{attrs:{data:e.tableData,height:e.Height-79,border:e.styleCode,"header-cell-style":e.headerCellFontWeight,"highlight-current-row":"","show-overflow-tooltip":"",align:"left"},on:{"row-dblclick":e.rowDblclick}},[i("el-table-column",{attrs:{prop:"Code",label:e.$t("menu.IndexTypeSet.5ncy6ooob5o0"),"show-overflow-tooltip":"",width:"200",align:"left"}}),e._v(" "),i("el-table-column",{attrs:{prop:"TypeDesc",label:e.$t("menu.IndexTypeSet.5ncy6ooobvk0"),"show-overflow-tooltip":"",width:"200",align:"left"}}),e._v(" "),i("el-table-column",{attrs:{prop:"StatusDesc",label:e.$t("menu.IndexTypeSet.5nrnbyiktto0"),"show-overflow-tooltip":"",width:"100",align:"left"},scopedSlots:e._u([{key:"default",fn:function(t){return[i("span",{style:{color:t.row.StatusDesc==e.$t("menu.IndexTypeSet.5nrnbyilhe80")?"green":"red"}},[e._v(e._s(t.row.StatusDesc))])]}}])}),e._v(" "),i("el-table-column",{attrs:{prop:"Remark",label:e.$t("menu.IndexTypeSet.5nrnbyinb8w0"),"show-overflow-tooltip":"","header-align":"left"}}),e._v(" "),e._e()],1),e._v(" "),i("hgpagination",{attrs:{styleCode:e.styleCode,sizes:[20,40,50,100],totalCount:e.totalCount,pageNumber:e.currentPage,pageSize:e.currentPageSize},on:{changePage:e.handleCurrentChange,getPageSize:e.handleSizeChange}})],1),e._v(" "),i("div",[i("el-dialog",{attrs:{title:0==e.winFlag?e.$t("menu.IndexTypeSet.5nrnbyijr880"):e.$t("menu.IndexTypeSet.5nrnbyio72g0"),visible:e.dialogVisible,"close-on-click-modal":!1,width:"414px",align:"center"},on:{"update:visible":function(t){e.dialogVisible=t}}},[i("div",{staticClass:"dialog-header-title",attrs:{slot:"title"},slot:"title"},[e.styleCode?i("i",{class:[0==e.winFlag?"nm-icon-w-plus":"nm-icon-w-edit"]}):e._e(),e._v(" "),0==e.winFlag?i("span",[e._v(e._s(e.$t("menu.IndexTypeSet.5nrnbyijr880")))]):1==e.winFlag?i("span",[e._v(e._s(e.$t("menu.IndexTypeSet.5nrnbyio72g0")))]):e._e()]),e._v(" "),i("el-form",{ref:"editForm",attrs:{model:e.editForm,rules:e.rules,"label-width":"150px","label-position":"right"}},[i("el-form-item",{attrs:{label:e.$t("menu.IndexTypeSet.5ncy6ooso8o0"),prop:"Code"}},[i("el-input",{style:e.labelWidth,attrs:{disabled:!!e.editForm.rw,size:"mini"},model:{value:e.editForm.Code,callback:function(t){e.$set(e.editForm,"Code",t)},expression:"editForm.Code"}})],1),e._v(" "),i("el-form-item",{attrs:{label:e.$t("menu.IndexTypeSet.5ncy6oosscw0"),prop:"TypeDesc"}},[i("el-input",{style:e.labelWidth,attrs:{size:"mini"},model:{value:e.editForm.TypeDesc,callback:function(t){e.$set(e.editForm,"TypeDesc",t)},expression:"editForm.TypeDesc"}})],1),e._v(" "),i("el-form-item",{attrs:{label:e.$t("menu.IndexTypeSet.5nrnbyiktto0"),prop:"Status"}},[i("hgswitch",{attrs:{"inactive-value":"N","active-value":"Y","active-text":e.$t("menu.IndexTypeSet.5nrnbyilhe80"),"inactive-text":e.$t("menu.IndexTypeSet.5nrnbyirsak0")},model:{value:e.editForm.Status,callback:function(t){e.$set(e.editForm,"Status",t)},expression:"editForm.Status"}})],1),e._v(" "),i("el-form-item",{attrs:{label:e.$t("menu.IndexTypeSet.5nrnbyisvk80"),prop:"Remark"}},[i("el-input",{style:e.labelWidth,attrs:{size:"mini"},model:{value:e.editForm.Remark,callback:function(t){e.$set(e.editForm,"Remark",t)},expression:"editForm.Remark"}})],1)],1),e._v(" "),i("div",{staticClass:"bottom-button"},[i("hgbutton",{attrs:{type:e.styleCode?"default":"success",styleCode:e.styleCode},on:{click:e.saveClick}},[e._v(e._s(e.$t("menu.IndexTypeSet.5nrnbyisxzs0")))]),e._v(" "),i("hgbutton",{attrs:{type:"default",styleCode:e.styleCode},on:{click:function(t){e.dialogVisible=!1}}},[e._v(e._s(e.$t("menu.IndexTypeSet.5nrnbyisyuo0")))])],1)],1)],1)])},staticRenderFns:[]},u=i("VU/8")(d,c,!1,null,null,null);t.default=u.exports}});