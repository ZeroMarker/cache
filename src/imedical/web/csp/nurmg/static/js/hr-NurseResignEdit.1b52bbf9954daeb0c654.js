webpackJsonp([168,292],{PQ0e:function(e,t,s){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var n=s("Dd8w"),i=s.n(n),r=s("NYxO"),a=s("XlQt"),o=s("W5Fe"),l=s("z8xk"),g=s("Icdr");s("GbHy"),s("Vb+l"),s("Oq2I"),s("miEh");var u={components:{hgbutton:a.default,hgpagination:o.default,hgpanel:l.default},computed:i()({},Object(r.b)(["Height","SysTomcat","LoginId","DateFormat","MonthFormat","styleCode"])),name:"NurseResign",data:function(){return{pageSize:{width:"",height:""},tableHeight:"",statestore:[{desc:"未提交",code:"N"},{desc:"已提交",code:"Y"},{desc:"已审核",code:"A"},{desc:"驳回",code:"B"}],nursewarddata:[],nurseresigntable:[],nurseresigntableAll:[],nurseresignform:{nurseno:"",nursenward:"",stdate:new Date((new Date).getFullYear(),(new Date).getMonth(),1),enddate:new Date((new Date).getFullYear(),(new Date).getMonth()+1,0),state:""},checkrow:"",pagesize:20,currentPage:1,totalCount:0,elementlist:[],dialogResignVisible:!1,nurseresignedit:{ResignName:"",ResignWard:"",ResignDate:"",ResignReason:[],ResignOther:"",RowID:""},rules:{ResignName:[{required:!0,message:"请选择离职人员",trigger:"change"}],ResignWard:[{required:!0,message:"病区不能为空！",trigger:"change"}]},showFlag:!1,resignInfoStore:[],resignWardStore:[],reasonstore:[],nurseresigncheck:{Opinion:""},checkrules:{Opinion:[{required:!0,message:"请填写审核意见",trigger:"blur"}]},toprole:"",dialogReasonVisible:!1,xData:[],yData:[],legendData:[],rateData:[],year:(new Date).getMonthDate(1).getMonthDate(1),colors:["#c1232B","#b6a2de","#5ab1ef","#ffb980","#d87a80","#d898b3","#e5cf0d","#97b552","#dc69aa","#07a2a4","#9a7fd1","#f5994e","#c05050","#c14089","#c9ab00","#7eb00a","#6f5553"],winFlag:0}},methods:{loadReasonChart:function(){var e=this;e.yData=new Array,e.legendData=new Array,e.rateData=[];var t=e.year;t instanceof Date&&(t=t.Format("YYYY-MM-dd")),e.$ajax.request(e.axiosConfig("web.INMInternComm","GetResignReason","Method","parr$离职原因")).then(function(s){e.$ajax(e.axiosConfig("web.INMInternComm","GetResignData","Method","parr$离职原因","year$"+t,"type$N")).then(function(t){e.xData=s.data,e.rateData=t.data,e.drawPieCharts()})})},yearChangeEvent:function(e){this.loadReasonChart()},drawPieCharts:function(){var e=this,t=e.yData;t||(t=new Array);e.$nextTick(function(){g.dispose(document.getElementById("ResignReasonChart")),g.init(document.getElementById("ResignReasonChart")).setOption({title:{text:"离职原因占比",x:"center"},color:e.colors,tooltip:{trigger:"item",formatter:"{a}<br/>{b}:{c}({d}%)"},legend:{orient:"vertical",x:"left",data:e.xData},toolbox:{show:!0,feature:{mark:{show:!0},dataView:{show:!1,readOnly:!1},magicType:{show:!0,type:["pie","funnel"],opinion:{funnel:{x:"25%",width:"50%",funnelAlign:"left",max:1548}}},restore:{show:!1},saveAsImage:{show:!0}}},calculbale:!0,series:[{name:"离职原因占比",type:"pie",redius:"55%",center:["60%","60%"],minShowLabelAngle:1,data:e.rateData}]})})},reasonStatic:function(){this.dialogReasonVisible=!0,this.loadReasonChart()},ward_change:function(){this.loadNurseStore()},loadTopRole:function(){var e=this;e.$ajax.request(e.axiosConfig("web.INMLoginComm","GetTopRoleByLoginId","Method","id$"+sessionStorage.getItem("loginID"))).then(function(t){e.toprole=t.data.split("^")[1]})},loadNurseStore:function(){var e=this;if(e.nurseresignedit.ResignWard){var t=e.nurseresignedit.ResignWard;e.resignInfoStore=new Array,"nurhead"==e.toprole||"znurhead"==e.toprole||"hlb"==e.toprole||"hlbzr"==e.toprole||"DEMO"==e.toprole?e.$ajax.request(e.axiosConfig("web.INMPersonComm","FindNurInfoOfWard","RecQuery","parr$"+t,"role$"+sessionStorage.getItem("loginRoleCodes"),"nurseid$"+sessionStorage.getItem("loginID"))).then(function(t){e.resignInfoStore=t.data.rows}):e.resignInfoStore.push({nursename:sessionStorage.loginName,nurseno:sessionStorage.loginCode,nurserow:sessionStorage.loginPerID,nursedep:t})}},setSize:function(){this.pageSize.width=document.documentElement.clientWidth-180+"px",this.pageSize.height=document.documentElement.clientHeight-100+"px"},loadLocData:function(){var e,t=this;e=t.axiosConfig("web.INMDataLimit","FindRoleWardList","RecQuery","role$"+sessionStorage.getItem("loginRoleCodes"),"nurseid$"+sessionStorage.getItem("loginID")),t.$ajax.request(e).then(function(e){t.nursewarddata=e.data.rows})},addResignData:function(){var e=this;e.winFlag=0,e.dialogResignVisible=!0,e.$nextTick(function(){e.$refs.nurseresignedit.resetFields(),e.resignInfoStore=new Array,e.nurseresignedit.RowID="",e.showFlag=!0})},rowDbClickEvent:function(e,t){var s=this;s.winFlag=1,s.$ajax.request(s.axiosConfig("web.INMInternComm","GetResignStatu","Method","id$"+e.rowid)).then(function(t){if(""==t.data||"N"==t.data||"B"==t.data)s.dialogResignVisible=!0,s.$nextTick(function(){s.$refs.nurseresignedit.resetFields(),s.$refs.nurseresigncheck.resetFields(),s.showFlag=!0,s.loadEditData(e.rowid)});else{if("Y"==t.data)return void s.$message({type:"warning",message:"已经提交，不能修改",showClose:!0,customClass:"warning_class"});if("A"==t.data)return void s.$message({type:"warning",message:"已经审核，不能修改！",showClose:!0,customClass:"warning_class"})}})},rowClickEvent:function(e,t,s){this.checkrow=e.rowid},delResignData:function(){var e=this;""!=e.checkrow?e.$ajax.request(e.axiosConfig("web.INMInternComm","GetResignStatu","Method","id$"+e.checkrow)).then(function(t){"Y"!=t.data?"A"!=t.data?e.$confirm("此操作将永久删除该记录, 是否继续?","提示",{confirmButtonText:"确定",cancelButtonText:"取消",type:"warning"}).then(function(){e.$ajax.request(e.axiosConfig("web.INMInternComm","DelResignRec","Method","id$"+e.checkrow)).then(function(t){1==t.data?(e.$message({type:"success",message:"删除成功",showClose:!0,customClass:"success_class"}),e.searchResignData()):e.$message({type:"warning",message:"删除失败",showClose:!0,customClass:"warning_class"})})}).catch(function(){e.$message({type:"info",message:"已取消删除",showClose:!0,customClass:"info_class"})}):e.$message({type:"warning",message:"已经审核不能删除",showClose:!0,customClass:"warning_class"}):e.$message({type:"warning",message:"已经提交不能删除",showClose:!0,customClass:"warning_class"})}):e.$message({type:"warning",message:"请选择要删除的记录",showClose:!0,customClass:"warning_class"})},checkResignData:function(){var e=this;""!=e.checkrow?(e.winFlag=3,e.$ajax.request(e.axiosConfig("web.INMInternComm","GetResignStatu","Method","id$"+e.checkrow)).then(function(t){if("Y"==t.data)e.dialogResignVisible=!0,e.$nextTick(function(){e.$refs.nurseresignedit.resetFields(),e.$refs.nurseresigncheck.resetFields(),e.showFlag=!1,e.loadEditData(e.checkrow)});else{if("A"==t.data)return void e.$message({type:"warning",message:"此记录已经审核，请勿重复审核！",showClose:!0,customClass:"warning_class"});if("B"==t.data)return void e.$message({type:"warning",message:"已驳回，请勿重复审核！",showClose:!0,customClass:"warning_class"});if("N"==t.data)return void e.$message({type:"warning",message:"未提交，不能审核！",showClose:!0,customClass:"warning_class"})}})):e.$message({type:"warning",message:"请选择要审核的记录",showClose:!0,customClass:"warning_class"})},searchResignData:function(){var e,t=this,s=t.nurseresignform.nurseno,n=t.nurseresignform.nursenward,i=t.nurseresignform.stdate;i=i instanceof Date?i.Format("YYYY-MM-dd"):"";var r=t.nurseresignform.enddate;e=s+"^"+n+"^"+i+"^"+(r=r instanceof Date?r.Format("YYYY-MM-dd"):"")+"^"+t.nurseresignform.state,t.$ajax.request(t.axiosConfig("web.INMInternComm","FindResignLists","RecQuery","parr$"+e,"nursetype$N","role$"+sessionStorage.getItem("loginRoleCodes"),"nurseid$"+sessionStorage.getItem("loginID"))).then(function(e){t.nurseresigntable=e.data.rows.slice((t.currentPage-1)*t.pagesize,(t.currentPage-1)*t.pagesize+t.pagesize),t.nurseresigntableAll=e.data.rows,NaN!=parseInt(e.data.results)?t.totalCount=parseInt(e.data.results):t.totalCount=0,t.checkrow=""})},handleSizeChange:function(e){this.pagesize=e,this.searchResignData()},handleCurrentChange:function(e){this.currentPage=e.currentPage,this.searchResignData()},loadResignInfoStore:function(){var e=this;e.$ajax.request(e.axiosConfig("web.INMInternComm","FindInternInfo","RecQuery","start$0","limit$10000","parr$","nursetype$N","role$"+sessionStorage.getItem("loginRoleCodes"),"nurseid$"+sessionStorage.getItem("loginID"))).then(function(t){e.resignInfoStore=t.data.rows})},loadResignWardStore:function(){var e=this,t=e.axiosConfig("web.INMDataLimit","FindRoleWardList","RecQuery","role$"+sessionStorage.getItem("loginRoleCodes"),"nurseid$"+sessionStorage.getItem("loginID"));e.$ajax.request(t).then(function(t){e.resignWardStore=t.data.rows})},loadEditData:function(e){var t=this;t.$nextTick(function(){e&&t.$ajax.request(t.axiosConfig("web.INMInternComm","GetResign","RecMethod","id$"+e)).then(function(e){t.isEmptyObject(e.data)||(t.setFormValue(e.data,"nurseresignedit"),e.data.ResignReason&&(t.nurseresignedit.ResignReason=e.data.ResignReason.split("~")),t.ward_change())})})},setFormValue:function(e,t){for(var s in this[t]){for(var n=this.$refs[t].$children,i=n.length,r=0;r<i;r++)n[r].$options.propsData.prop==s&&("el-date-picker"==n[r].$children[1].$options._componentTag?e[s]?this[t][s]=new Date(Date.parse(e[s].replace(/-/g,"/"))):this[t][s]=e[s]:"el-checkbox-group"==n[r].$children[1].$options._componentTag?e.ResignReason&&(this[t][s]=e.ResignReason.split(",")):this[t][s]=e[s]);"RowID"!=s&&"ResignOther"!=s||(this[t][s]=e[s])}},handlerSure:function(e,t,s){for(var n=this,i="",r=n.$refs[e].$children,a=r.length,o=0;o<a;o++){var l=r[o].$options.propsData;if("el-date-picker"==r[o].$children[1].$options._componentTag)i=n[e][l.prop]?i?i+"^"+l.prop+"|"+n[e][l.prop].Format("YYYY-MM-dd"):l.prop+"|"+n[e][l.prop].Format("YYYY-MM-dd"):i?i+"^"+l.prop+"|"+n[e][l.prop]:l.prop+"|"+n[e][l.prop];else if("el-checkbox-group"==r[o].$children[1].$options._componentTag){for(var g=r[o].$children[1].$children,u=g.length,d="",c=0;c<u;c++)if(1==g[c].isChecked){var m=g[c].label;d=d?d+"~"+m.replace("||","__"):m.replace("||","__")}i&&(i=i+"^"+r[o].prop+"|"+d)}else i=n[e][l.prop]?i?i+"^"+l.prop+"|"+n[e][l.prop].toString().replace("||","__"):l.prop+"|"+n[e][l.prop].toString().replace("||","__"):i?i+"^"+l.prop+"|"+n[e][l.prop]:l.prop+"|"+n[e][l.prop]}i=i+"^RowID|"+n[e].RowID+"^ResignType|"+t+"^ResignCreater|"+sessionStorage.getItem("loginID")+"^ResignStatus|"+s+"^ResignOther|"+n[e].ResignOther,n.$refs[e].validate(function(e){e&&n.$ajax.request(n.axiosConfig("web.INMInternComm","SaveResign","Method","parr$"+i)).then(function(e){if(e.data>0)n.$message({type:"success",message:"更新成功",showClose:!0,customClass:"success_class"}),n.dialogResignVisible=!1,n.searchResignData();else if(0==e.data)return void n.$message({type:"warning",message:"请勿重复申请，更新失败",showClose:!0,customClass:"warning_class"})})})},checkHandlerSure:function(e,t){var s=this;s.$refs.nurseresigncheck.validate(function(n){if(n){var i="";if("A"==t){if(!s.nurseresignedit.ResignDate)return void s.$message({type:"warning",message:"请填写离职日期！",showClose:!0,customClass:"warning_class"});i=s.nurseresignedit.ResignDate.Format("YYYY-MM-dd")}var r=s.nurseresigncheck.Opinion,a=sessionStorage.getItem("loginID");s.$ajax.request(s.axiosConfig("web.INMInternComm","CheckResignRec","Method","id$"+s.checkrow,"type$"+e,"status$"+t,"parr$"+r+"^"+a+"^"+i)).then(function(e){1==e.data&&(s.dialogResignVisible=!1,s.searchResignData())})}})},isEmptyObject:function(e){var t;for(t in e)return!1;return!0}},created:function(){var e=this;e.setSize(),e.tableHeight=e.$store.state.mainframe.Height-130,e.loadLocData(),e.searchResignData(),e.loadTopRole(),e.loadSysParamSubData("离职原因","reasonstore"),e.loadResignWardStore();var t=e.$router.currentRoute.path.slice(1,e.$router.currentRoute.path.length);e.$nextTick(function(){e.loadElementsForRouter("elementlist",t)})}},d={render:function(){var e=this,t=e.$createElement,s=e._self._c||t;return s("div",{staticClass:"nurseresign-panel"},[s("div",{staticClass:"top-tool-inputDiv"},[s("el-form",{attrs:{inline:!0,model:e.nurseresignform,"label-position":"left"}},[s("el-form-item",{attrs:{label:e.$t("menu.NurseResign.5nrnbfwq4040")}},[s("el-select",{staticStyle:{width:"140px"},attrs:{filterable:"",clearable:"",placeholder:e.$t("menu.NurseResign.5nrnbfwrae40"),size:"mini"},model:{value:e.nurseresignform.nursenward,callback:function(t){e.$set(e.nurseresignform,"nursenward",t)},expression:"nurseresignform.nursenward"}},e._l(e.nursewarddata,function(e){return s("el-option",{key:e.rw,attrs:{label:e.WardDesc,value:e.rw}})}),1)],1),e._v(" "),s("el-form-item",{attrs:{label:e.$t("menu.NurseResign.5nrnbfwse300")}},[s("el-input",{staticStyle:{width:"100px"},attrs:{placeholder:e.$t("menu.NurseResign.5nrnbfwtkvg0"),size:"mini"},model:{value:e.nurseresignform.nurseno,callback:function(t){e.$set(e.nurseresignform,"nurseno",t)},expression:"nurseresignform.nurseno"}})],1),e._v(" "),s("el-form-item",{attrs:{label:e.$t("menu.NurseResign.5nrnbfwv5s80")}},[s("el-date-picker",{staticStyle:{width:"120px"},attrs:{type:"date",format:this.$store.state.mainframe.DateFormat,placeholder:e.$t("menu.NurseResign.5nrnbfwv5s80"),size:"mini"},model:{value:e.nurseresignform.stdate,callback:function(t){e.$set(e.nurseresignform,"stdate",t)},expression:"nurseresignform.stdate"}})],1),e._v(" "),s("el-form-item",{attrs:{label:e.$t("menu.NurseResign.5nrnbfwy3000")}},[s("el-date-picker",{staticStyle:{width:"120px"},attrs:{type:"date",format:this.$store.state.mainframe.DateFormat,placeholder:e.$t("menu.NurseResign.5nrnbfwy3000"),size:"mini"},model:{value:e.nurseresignform.enddate,callback:function(t){e.$set(e.nurseresignform,"enddate",t)},expression:"nurseresignform.enddate"}})],1),e._v(" "),s("el-form-item",{attrs:{label:e.$t("menu.NurseResign.5nrnbfx10oc0")}},[s("el-select",{staticStyle:{width:"110px"},attrs:{filterable:"",clearable:"",placeholder:e.$t("menu.NurseResign.5nrnbfx28lk0"),size:"mini"},model:{value:e.nurseresignform.state,callback:function(t){e.$set(e.nurseresignform,"state",t)},expression:"nurseresignform.state"}},e._l(e.statestore,function(e){return s("el-option",{key:e.code,attrs:{label:e.desc,value:e.code}})}),1)],1),e._v(" "),s("el-form-item",[this.elementlist.resignsearch||0==e.LoginId?s("hgbutton",{ref:"resignsearch",attrs:{type:"default",styleCode:e.styleCode,icon:"nm-icon-w-find"},on:{click:e.searchResignData}},[e._v(e._s(e.$t("menu.NurseResign.5nrnbfx2a5c0")))]):e._e()],1)],1)],1),e._v(" "),s("div",{staticClass:"top-tool-button"},[this.elementlist.resignadd||0==e.LoginId?s("hgbutton",{ref:"resignadd",attrs:{type:"text",issvg:e.styleCode,icon:e.styleCode?"#nm-icon-add":"nm-icon-lite-add"},on:{click:e.addResignData}},[e._v(e._s(e.$t("menu.NurseResign.5nrnbfx2az40")))]):e._e(),e._v(" "),this.elementlist.resigndel||0==e.LoginId?s("hgbutton",{ref:"resigndel",attrs:{type:"text",issvg:e.styleCode,icon:e.styleCode?"#nm-icon-cancel":"nm-icon-lite-cancel"},on:{click:e.delResignData}},[e._v(e._s(e.$t("menu.NurseResign.5nrnbfx2be80")))]):e._e(),e._v(" "),this.elementlist.resignaudit||0==e.LoginId?s("hgbutton",{ref:"resignaudit",attrs:{type:"text",issvg:e.styleCode,icon:e.styleCode?"#nm-icon-stamp":"nm-icon-lite-stamp"},on:{click:e.checkResignData}},[e._v(e._s(e.$t("menu.NurseResign.5nrnbfx2bs80")))]):e._e(),e._v(" "),this.elementlist.resignreason||0==e.LoginId?s("hgbutton",{ref:"resignreason",attrs:{type:"text",issvg:e.styleCode,icon:e.styleCode?"#nm-icon-doc-caseload":"nm-icon-lite-caseload"},on:{click:e.reasonStatic}},[e._v(e._s(e.$t("menu.NurseResign.5nrnbfx2cps0")))]):e._e(),e._v(" "),this.elementlist.exportedit||0==e.LoginId?s("hgbutton",{attrs:{type:"text",issvg:e.styleCode,icon:e.styleCode?"#nm-icon-export":"nm-icon-lite-export"},on:{click:function(t){e.exportData("nurseresigntable",e.nurseresigntableAll,e.$t("menu.NurseResign.5ncy6drzcc00"))}}},[e._v(e._s(e.$t("menu.NurseResign.5nrnbfx2d6c0")))]):e._e()],1),e._v(" "),s("div",{staticClass:"top-tool-table"},[s("el-table",{ref:"nurseresigntable",staticStyle:{width:"100%"},attrs:{"highlight-current-row":!0,data:e.nurseresigntable,"header-cell-style":e.headerCellFontWeight,border:e.styleCode,height:e.styleCode?e.tableHeight:e.tableHeight+6},on:{"row-dblclick":e.rowDbClickEvent,"row-click":e.rowClickEvent}},[s("el-table-column",{attrs:{type:"index",width:"40",align:"center"}}),e._v(" "),s("el-table-column",{attrs:{prop:"resignStatuDesc",label:e.$t("menu.NurseResign.5nrnbfx10oc0"),width:"80"}}),e._v(" "),s("el-table-column",{attrs:{prop:"nurseID",label:e.$t("menu.NurseResign.5nrnbfx6lfc0"),"show-overflow-tooltip":"",width:"120"}}),e._v(" "),s("el-table-column",{attrs:{prop:"resignName",label:e.$t("menu.NurseResign.5nrnbfx87kw0"),"show-overflow-tooltip":"",width:"80"}}),e._v(" "),s("el-table-column",{attrs:{prop:"resignWard",label:e.$t("menu.NurseResign.5nrnbfwq4040")}}),e._v(" "),s("el-table-column",{attrs:{prop:"resignDate",label:e.$t("menu.NurseResign.5nrnbfxaxl40"),"show-overflow-tooltip":"",width:"100",formatter:e.PTableDateHisShow}}),e._v(" "),s("el-table-column",{attrs:{prop:"resignReason",label:e.$t("menu.NurseResign.5nrnbfx2cps0"),"show-overflow-tooltip":""}}),e._v(" "),s("el-table-column",{attrs:{prop:"creater",label:e.$t("menu.NurseResign.5nrnbfxfbl80"),"show-overflow-tooltip":"",width:"80"}}),e._v(" "),s("el-table-column",{attrs:{prop:"createDate",label:e.$t("menu.NurseResign.5nrnbfxhfyc0"),"show-overflow-tooltip":"",width:"100",formatter:e.PTableDateHisShow}}),e._v(" "),s("el-table-column",{attrs:{prop:"updateUser",label:e.$t("menu.NurseResign.5nrnbfxj3cs0"),"show-overflow-tooltip":"",width:"80"}}),e._v(" "),s("el-table-column",{attrs:{prop:"resignUpdate",label:e.$t("menu.NurseResign.5ncy6ds69ek0"),width:"130",formatter:e.PTableDateHisShow}}),e._v(" "),e._e()],1),e._v(" "),s("hgpagination",{attrs:{styleCode:e.styleCode,sizes:[20,40,50,100],totalCount:e.totalCount,pageNumber:e.currentPage,pageSize:e.pagesize},on:{changePage:e.handleCurrentChange,getPageSize:e.handleSizeChange}})],1),e._v(" "),s("div",[s("el-dialog",{attrs:{title:0==e.winFlag?e.$t("menu.NurseResign.5nrnbfx2az40"):1==e.winFlag?e.$t("menu.NurseResign.5nrnbfxm5580"):e.$t("menu.NurseResign.5nrnbfx2bs80"),modal:"","close-on-click-modal":!1,visible:e.dialogResignVisible,width:"720px",align:"left"},on:{"update:visible":function(t){e.dialogResignVisible=t}}},[s("div",{staticClass:"dialog-header-title",attrs:{slot:"title"},slot:"title"},[e.styleCode?s("i",{class:[0==e.winFlag?"nm-icon-w-plus":1==e.winFlag?"m-icon-w-edit":"nm-icon-w-paper"]}):e._e(),e._v(" "),0==e.winFlag?s("span",[e._v(e._s(e.$t("menu.NurseResign.5nrnbfx2az40")))]):1==e.winFlag?s("span",[e._v(e._s(e.$t("menu.NurseResign.5nrnbfxm5580")))]):s("span",[e._v(e._s(e.$t("menu.NurseResign.5nrnbfx2bs80")))])]),e._v(" "),s("div",{staticClass:"resignfieldset"},[s("hgpanel",{staticStyle:{width:"100%"},attrs:{title:e.$t("menu.NurseResign.5nrnbfxm9bk0"),styleCode:e.styleCode,icon:"#nm-icon-paper-table",panelHeight:330}},[s("div",{staticStyle:{"margin-top":"5px"}},[s("el-form",{ref:"nurseresignedit",attrs:{model:e.nurseresignedit,rules:e.rules,inline:!0,"label-position":"right",align:"left"}},[s("el-form-item",{staticStyle:{"margin-bottom":"0"},attrs:{label:e.$t("menu.NurseResign.5nrnbfwq4040"),prop:"ResignWard","label-width":"58px"}},[s("el-select",{staticStyle:{width:"120px"},attrs:{filterable:"",clearable:"",placeholder:e.$t("menu.NurseResign.5nrnbfwrae40"),size:"mini",disabled:!e.showFlag},on:{change:e.ward_change},model:{value:e.nurseresignedit.ResignWard,callback:function(t){e.$set(e.nurseresignedit,"ResignWard",t)},expression:"nurseresignedit.ResignWard"}},e._l(e.resignWardStore,function(e){return s("el-option",{key:e.rw,attrs:{label:e.WardDesc,value:e.rw}})}),1)],1),e._v(" "),s("el-form-item",{staticStyle:{"margin-bottom":"0"},attrs:{label:e.$t("menu.NurseResign.5nrnbfx87kw0"),prop:"ResignName","label-width":"80px"}},[s("el-select",{staticStyle:{width:"130px"},attrs:{filterable:"",clearable:"",placeholder:e.$t("menu.NurseResign.5nrnbfwrae40"),disabled:!e.showFlag,size:"mini"},model:{value:e.nurseresignedit.ResignName,callback:function(t){e.$set(e.nurseresignedit,"ResignName",t)},expression:"nurseresignedit.ResignName"}},e._l(e.resignInfoStore,function(e){return s("el-option",{key:e.nurserow,attrs:{label:e.nursename+e.nurseno,value:e.nurserow}})}),1)],1),e._v(" "),s("el-form-item",{staticStyle:{"margin-bottom":"0"},attrs:{label:e.$t("menu.NurseResign.5nrnbfxaxl40"),prop:"ResignDate","label-width":"80px"}},[s("el-date-picker",{staticStyle:{width:"150px"},attrs:{type:"date",format:this.$store.state.mainframe.DateFormat,placeholder:e.$t("menu.NurseResign.5nrnbfxuw0s0"),size:"mini",disabled:e.showFlag},model:{value:e.nurseresignedit.ResignDate,callback:function(t){e.$set(e.nurseresignedit,"ResignDate",t)},expression:"nurseresignedit.ResignDate"}})],1),e._v(" "),s("el-form-item",{staticClass:"resigncheck-panel",staticStyle:{"margin-left":"10px","font-size":"0"},attrs:{label:e.$t("menu.NurseResign.5nrnbfxwi5k0"),prop:"ResignReason"}},[s("el-checkbox-group",{model:{value:e.nurseresignedit.ResignReason,callback:function(t){e.$set(e.nurseresignedit,"ResignReason",t)},expression:"nurseresignedit.ResignReason"}},e._l(e.reasonstore,function(t){return s("el-checkbox",{key:t.SubDesc,staticStyle:{width:"50%",margin:"0",padding:"0px"},attrs:{label:t.SubValue,disabled:!e.showFlag}},[e._v(e._s(t.SubDesc))])}),1),e._v(" "),-1!=this.nurseresignedit.ResignReason.indexOf("22||15")?s("el-input",{staticStyle:{width:"500px",margin:"0px"},attrs:{size:"small",disabled:!e.showFlag},model:{value:e.nurseresignedit.ResignOther,callback:function(t){e.$set(e.nurseresignedit,"ResignOther",t)},expression:"nurseresignedit.ResignOther"}}):e._e()],1)],1)],1)]),e._v(" "),s("hgpanel",{directives:[{name:"show",rawName:"v-show",value:!e.showFlag,expression:"!showFlag"}],staticStyle:{width:"100%","margin-top":"10px"},attrs:{title:e.$t("menu.NurseResign.5nrnbfx2bs80"),styleCode:e.styleCode,icon:"#nm-icon-paper-table",panelHeight:94}},[s("div",{staticStyle:{"margin-top":"8px"}},[s("el-form",{ref:"nurseresigncheck",staticStyle:{width:"100%"},attrs:{model:e.nurseresigncheck,rules:e.checkrules,inline:!0,"label-width":"86px","label-position":"right",align:"left"}},[s("el-form-item",{attrs:{label:e.$t("menu.NurseResign.5nrnbfxzfcw0"),prop:"Opinion"}},[s("el-input",{staticStyle:{width:"602px","margin-bottom":"8px"},attrs:{type:"textarea",rows:1,size:"mini",placeholder:e.$t("menu.NurseResign.5nrnbfy158g0")},model:{value:e.nurseresigncheck.Opinion,callback:function(t){e.$set(e.nurseresigncheck,"Opinion",t)},expression:"nurseresigncheck.Opinion"}})],1)],1)],1)])],1),e._v(" "),s("div",{staticClass:"bottom-button"},[this.elementlist.resignsave||0==e.LoginId?s("hgbutton",{directives:[{name:"show",rawName:"v-show",value:e.showFlag,expression:"showFlag"}],ref:"resignsave",attrs:{type:e.styleCode?"default":"success",styleCode:e.styleCode},on:{click:function(t){return e.handlerSure("nurseresignedit","N","N")}}},[e._v(e._s(e.$t("menu.NurseResign.5nrnbfy181c0")))]):e._e(),e._v(" "),this.elementlist.resignsubmit||0==e.LoginId?s("hgbutton",{directives:[{name:"show",rawName:"v-show",value:e.showFlag,expression:"showFlag"}],ref:"resignsubmit",staticStyle:{width:"120px"},attrs:{type:"default",styleCode:e.styleCode},on:{click:function(t){return e.handlerSure("nurseresignedit","N","Y")}}},[e._v(e._s(e.$t("menu.NurseResign.5nrnbfy197k0")))]):e._e(),e._v(" "),this.elementlist.resignauditsure||0==e.LoginId?s("hgbutton",{directives:[{name:"show",rawName:"v-show",value:!e.showFlag,expression:"!showFlag"}],ref:"resignauditsure",attrs:{type:"default",styleCode:e.styleCode},on:{click:function(t){return e.checkHandlerSure("N","A")}}},[e._v(e._s(e.$t("menu.NurseResign.5nrnbfy1a140")))]):e._e(),e._v(" "),this.elementlist.resigndismisse||0==e.LoginId?s("hgbutton",{directives:[{name:"show",rawName:"v-show",value:!e.showFlag,expression:"!showFlag"}],ref:"resigndismisse",attrs:{type:"default",styleCode:e.styleCode},on:{click:function(t){return e.checkHandlerSure("N","B")}}},[e._v(e._s(e.$t("menu.NurseResign.5nrnbfy1at40")))]):e._e()],1)])],1),e._v(" "),s("div",[s("el-dialog",{attrs:{title:e.$t("menu.NurseResign.5nrnbfx2cps0"),modal:"","close-on-click-modal":!1,top:"4%",visible:e.dialogReasonVisible,width:"80%"},on:{"update:visible":function(t){e.dialogReasonVisible=t}}},[s("div",{staticClass:"dialog-header-title",attrs:{slot:"title"},slot:"title"},[e.styleCode?s("i",{staticClass:"nm-icon-w-paper"}):e._e(),e._v(" "),s("span",[e._v(e._s(e.$t("menu.NurseResign.5nrnbfx2cps0")))])]),e._v(" "),s("div",{staticStyle:{"text-align":"left"}},[s("el-date-picker",{attrs:{size:"mini",type:"year",placeholder:e.$t("menu.NurseResign.5nrnbfy4p680")},on:{change:e.yearChangeEvent},model:{value:e.year,callback:function(t){e.year=t},expression:"year"}}),e._v(" "),s("div",{staticStyle:{height:"450px","margin-top":"10px","margin-bottom":"20px"},attrs:{id:"ResignReasonChart"}})],1)])],1)])},staticRenderFns:[]};var c=s("VU/8")(u,d,!1,function(e){s("ffPB")},null,null);t.default=c.exports},"c8X+":function(e,t,s){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var n={name:"NurseResignEdit",data:function(){return{pageSize:{width:"",height:""},showFlag:!1,resignInfoStore:[],resignWardStore:[],reasonstore:[],nurseresignedit:{ResignName:"",ResignWard:"",ResignDate:"",ResignReason:[],ResignOther:"",RowID:""},rules:{ResignName:[{required:!0,message:"请选择离职人员",trigger:"change"}],ResignWard:[{required:!0,message:"病区不能为空！",trigger:"change"}],ResignDate:[{required:!0,message:"请选择离职日期！",trigger:"change",type:"date"}]},nurseresigncheck:{Opinion:""},checkrules:{Opinion:[{required:!0,message:"请填写审核意见",trigger:"blur"}]},elementlist:[]}},methods:{setSize:function(){this.pageSize.width=document.documentElement.clientWidth-180+"px",this.pageSize.height=document.documentElement.clientHeight-100+"px"},checkHandlerSure:function(e,t){var n=this;n.$refs.nurseresigncheck.validate(function(i){if(i){var r=n.nurseresigncheck.Opinion,a=sessionStorage.getItem("loginID");n.$ajax.request(n.axiosConfig("web.INMInternComm","CheckResignRec","Method","id$"+n.$route.params.nurseresignrid,"type$"+e,"status$"+t,"parr$"+r+"^"+a)).then(function(e){1==e.data&&(n.$router.addRoutes([{path:"/nurseresign",name:"护士离职",component:s("PQ0e")}]),n.$router.push({name:"护士离职"}))})}})},loadResignInfoStore:function(){var e=this;e.$ajax.request(e.axiosConfig("web.INMInternComm","FindInternInfo","RecQuery","start$0","limit$10000","parr$","nursetype$N","role$"+sessionStorage.getItem("loginRoleCodes"),"nurseid$"+sessionStorage.getItem("loginID"))).then(function(t){e.resignInfoStore=t.data.rows})},loadResignWardStore:function(){var e=this,t=e.axiosConfig("web.INMDataLimit","FindRoleWardList","RecQuery","role$"+sessionStorage.getItem("loginRoleCodes"),"nurseid$"+sessionStorage.getItem("loginID"));e.$ajax.request(t).then(function(t){e.resignWardStore=t.data.rows})},nurseChangeEvent:function(){var e=this;e.$nextTick(function(){var t;void 0!=e.nurseresignedit.ResignName&&""!=e.nurseresignedit.ResignName&&(t=e.resignInfoStore.find(function(t){return t.rowid===e.nurseresignedit.ResignName}),e.nurseresignedit.ResignWard=t.inWardCode)})},clearForm:function(){this.nurseresignedit={ResignName:"",ResignWard:"",ResignDate:"",ResignReason:[],ResignOther:"",RowID:""}},handlerSure:function(e,t,n){for(var i=this,r="",a=i.$refs[e].$children,o=a.length,l=0;l<o;l++){var g=a[l].$options.propsData;if("el-date-picker"==a[l].$children[0].$options._componentTag)r=i[e][g.prop]?r?r+"^"+g.prop+"|"+i[e][g.prop].Format("YYYY-MM-dd"):g.prop+"|"+i[e][g.prop].Format("YYYY-MM-dd"):r?r+"^"+g.prop+"|"+i[e][g.prop]:g.prop+"|"+i[e][g.prop];else if("el-checkbox-group"==a[l].$children[0].$options._componentTag){for(var u=a[l].$children[0].$children,d=u.length,c="",m=0;m<d;m++)if(1==u[m].isChecked){var p=u[m].label;c=c?c+"~"+p.replace("||","__"):p.replace("||","__")}r&&(r=r+"^"+a[l].prop+"|"+c)}else r=i[e][g.prop]?r?r+"^"+g.prop+"|"+i[e][g.prop].replace("||","__"):g.prop+"|"+i[e][g.prop].replace("||","__"):r?r+"^"+g.prop+"|"+i[e][g.prop]:g.prop+"|"+i[e][g.prop]}r=r+"^RowID|"+i[e].RowID+"^ResignType|"+t+"^ResignCreater|"+sessionStorage.getItem("loginID")+"^ResignStatus|"+n+"^ResignOther|"+i[e].ResignOther,i.$refs[e].validate(function(e){e&&i.$ajax.request(i.axiosConfig("web.INMInternComm","SaveResign","Method","parr$"+r)).then(function(e){if(e.data>0)i.$message({type:"success",message:"更新成功",showClose:!0,customClass:"success_class"}),i.$router.addRoutes([{path:"/nurseresign",name:"护士离职",component:s("PQ0e")}]),i.$router.push({name:"护士离职"});else if(0==e.data)return void i.$message({type:"warning",message:"请勿重复申请，更新失败",showClose:!0,customClass:"warning_class"})})})},loadEditData:function(){var e=this,t=e.$route.params.nurseresignrid;e.$nextTick(function(){t&&e.$ajax.request(e.axiosConfig("web.INMInternComm","GetResign","RecMethod","id$"+t)).then(function(t){e.isEmptyObject(t.data)||e.setFormValue(t.data,"nurseresignedit")})})},setFormValue:function(e,t){for(var s in this[t]){for(var n=this.$refs[t].$children,i=n.length,r=0;r<i;r++)n[r].$options.propsData.prop==s&&("el-date-picker"==n[r].$children[0].$options._componentTag?e[s]?this[t][s]=new Date(Date.parse(e[s].replace(/-/g,"/"))):this[t][s]=e[s]:"el-checkbox-group"==n[r].$children[0].$options._componentTag?e.ResignReason&&(this[t][s]=e.ResignReason.split("~")):this[t][s]=e[s]);"RowID"!=s&&"ResignOther"!=s||(this[t][s]=e[s])}},isEmptyObject:function(e){var t;for(t in e)return!1;return!0},setShowFlag:function(){this.showFlag=this.$route.params.showflag}},watch:{"nurseresignedit.ResignReason":{handler:function(e,t){-1==e.indexOf("22||15")&&-1!=t.indexOf("22||15")&&(this.nurseresignedit.ResignOther="")}}},created:function(){var e=this;e.setSize(),e.setShowFlag(),e.loadResignInfoStore(),e.loadSysParamSubData("reasonstore","离职原因"),e.loadEditData(),e.loadResignWardStore();var t=e.$router.currentRoute.path.slice(1,e.$router.currentRoute.path.length);e.$nextTick(function(){e.loadElementsForRouter("elementlist",sessionStorage.loginRoleCodes,t)})}},i={render:function(){var e=this,t=e.$createElement,s=e._self._c||t;return s("div",{directives:[{name:"show",rawName:"v-show",value:!0,expression:"true"}],style:e.pageSize},[s("div",{staticClass:"conditions"},[this.elementlist.resignsave||0==e.LoginId?s("el-button",{directives:[{name:"show",rawName:"v-show",value:e.showFlag,expression:"showFlag"}],ref:"resignsave",attrs:{type:"primary",size:"mini"},on:{click:function(t){return e.handlerSure("nurseresignedit","N","N")}}},[e._v(e._s(e.$t("menu.NurseResignEdit.5nrnbg3so8g0")))]):e._e(),e._v(" "),this.elementlist.resignsubmit||0==e.LoginId?s("el-button",{directives:[{name:"show",rawName:"v-show",value:e.showFlag,expression:"showFlag"}],ref:"resignsubmit",attrs:{type:"primary",size:"mini"},on:{click:function(t){return e.handlerSure("nurseresignedit","N","Y")}}},[e._v(e._s(e.$t("menu.NurseResignEdit.5nrnbg3sp1s0")))]):e._e(),e._v(" "),this.elementlist.resignaudit||0==e.LoginId?s("el-button",{directives:[{name:"show",rawName:"v-show",value:!e.showFlag,expression:"!showFlag"}],ref:"resignaudit",attrs:{type:"primary",size:"mini"},on:{click:function(t){return e.checkHandlerSure("N","A")}}},[e._v(e._s(e.$t("menu.NurseResignEdit.5nrnbg3sphc0")))]):e._e(),e._v(" "),this.elementlist.resigndismisse||0==e.LoginId?s("el-button",{directives:[{name:"show",rawName:"v-show",value:!e.showFlag,expression:"!showFlag"}],ref:"resigndismisse",attrs:{type:"primary",size:"mini"},on:{click:function(t){return e.checkHandlerSure("N","B")}}},[e._v(e._s(e.$t("menu.NurseResignEdit.5nrnbg3spvc0")))]):e._e()],1),e._v(" "),s("div",{staticStyle:{height:"500px"}},[s("el-form",{ref:"nurseresignedit",attrs:{model:e.nurseresignedit,rules:e.rules,inline:!0,"label-width":"120px","label-position":"right"}},[s("fieldset",{staticClass:"resign_fieldset",staticStyle:{border:"1px solid #8db3e3",padding:"0px 0px 0px 10px"}},[s("legend",[s("font",{staticStyle:{color:"red"}},[e._v(e._s(e.$t("menu.NurseResignEdit.5nrnbg3sr1o0")))])],1),e._v(" "),s("el-form-item",{staticClass:"resign_form_item",attrs:{label:e.$t("menu.NurseResignEdit.5nrnbg3srgo0"),prop:"ResignName"}},[s("el-select",{staticStyle:{width:"180px"},attrs:{filterable:"",clearable:"",placeholder:e.$t("menu.NurseResignEdit.5nrnbg3srz00"),disabled:!e.showFlag,size:"small"},model:{value:e.nurseresignedit.ResignName,callback:function(t){e.$set(e.nurseresignedit,"ResignName",t)},expression:"nurseresignedit.ResignName"}},e._l(e.resignInfoStore,function(e){return s("el-option",{key:e.rowid,attrs:{label:e.internInfo,value:e.rowid}})}),1)],1),e._v(" "),s("el-form-item",{staticClass:"resign_form_item",attrs:{label:e.$t("menu.NurseResignEdit.5nrnbg3ssk40"),prop:"ResignWard"}},[s("el-select",{staticStyle:{width:"220px"},attrs:{filterable:"",clearable:"",placeholder:e.$t("menu.NurseResignEdit.5nrnbg3srz00"),size:"small",disabled:!e.showFlag},model:{value:e.nurseresignedit.ResignWard,callback:function(t){e.$set(e.nurseresignedit,"ResignWard",t)},expression:"nurseresignedit.ResignWard"}},e._l(e.resignWardStore,function(e){return s("el-option",{key:e.rw,attrs:{label:e.WardDesc,value:e.rw}})}),1)],1),e._v(" "),s("el-form-item",{attrs:{label:e.$t("menu.NurseResignEdit.5nrnbg3stdo0"),prop:"ResignDate"}},[s("el-date-picker",{staticStyle:{width:"180px"},attrs:{type:"date",format:this.$store.state.mainframe.DateFormat,placeholder:e.$t("menu.NurseResignEdit.5nrnbg3stuc0"),size:"small",disabled:!e.showFlag},model:{value:e.nurseresignedit.ResignDate,callback:function(t){e.$set(e.nurseresignedit,"ResignDate",t)},expression:"nurseresignedit.ResignDate"}})],1),e._v(" "),s("el-form-item",{staticStyle:{"margin-left":"20px"},attrs:{label:e.$t("menu.NurseResignEdit.5nrnbg3su7s0"),prop:"ResignReason"}},[s("el-checkbox-group",{model:{value:e.nurseresignedit.ResignReason,callback:function(t){e.$set(e.nurseresignedit,"ResignReason",t)},expression:"nurseresignedit.ResignReason"}},e._l(e.reasonstore,function(t){return s("el-checkbox",{key:t.SubDesc,staticStyle:{width:"50%",margin:"0",padding:"0px"},attrs:{label:t.SubValue,disabled:!e.showFlag}},[e._v(e._s(t.SubDesc))])}),1),e._v(" "),-1!=this.nurseresignedit.ResignReason.indexOf("22||15")?s("el-input",{staticStyle:{width:"500px",margin:"0px"},attrs:{size:"small",disabled:!e.showFlag},model:{value:e.nurseresignedit.ResignOther,callback:function(t){e.$set(e.nurseresignedit,"ResignOther",t)},expression:"nurseresignedit.ResignOther"}}):e._e()],1)],1)]),e._v(" "),s("el-form",{directives:[{name:"show",rawName:"v-show",value:!e.showFlag,expression:"!showFlag"}],ref:"nurseresigncheck",attrs:{model:e.nurseresigncheck,rules:e.checkrules,inline:!0,"label-width":"110px","label-position":"right"}},[s("fieldset",{staticClass:"resign_fieldset",staticStyle:{border:"1px solid #8db3e3",padding:"0px 0px 0px 10px",margin:"0 5px"}},[s("legend",[s("font",{staticStyle:{color:"red"}},[e._v(e._s(e.$t("menu.NurseResignEdit.5nrnbg3sphc0")))])],1),e._v(" "),s("el-form-item",{attrs:{label:e.$t("menu.NurseResignEdit.5nrnbg3svt80"),prop:"Opinion"}},[s("el-input",{staticStyle:{width:"525px"},attrs:{type:"textarea",rows:1,placeholder:e.$t("menu.NurseResignEdit.5nrnbg3sw700")},model:{value:e.nurseresigncheck.Opinion,callback:function(t){e.$set(e.nurseresigncheck,"Opinion",t)},expression:"nurseresigncheck.Opinion"}})],1)],1)])],1)])},staticRenderFns:[]},r=s("VU/8")(n,i,!1,null,null,null);t.default=r.exports},ffPB:function(e,t){}});