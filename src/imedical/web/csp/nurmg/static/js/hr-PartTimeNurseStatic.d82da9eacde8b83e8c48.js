webpackJsonp([284],{"7QLb":function(e,t){},eomd:function(e,t,a){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var r=a("Dd8w"),o=a.n(r),l=a("NYxO"),n=a("zL8q"),i=a("XlQt"),s=a("W5Fe"),c={components:{hgbutton:i.default,hgpagination:s.default},computed:o()({},Object(l.b)(["Height","LoginId","DateFormat","styleCode"])),name:"PartTimeNurse",data:function(){return{searchform:{StDate:new Date((new Date).getFullYear(),(new Date).getMonth(),1),EndDate:new Date((new Date).getFullYear(),(new Date).getMonth()+1,0),Person:"",WorkLoc:"",Loc:""},statusstore:[{code:"A",desc:"已审核"},{code:"Y",desc:"已提交"}],totalData:[],tableData:[],workLocStore:[],locdata:[],elementlist:[],currentPage:1,currentPageSize:20,totalCount:0,drawer:!1,DetailData:[]}},created:function(){this.loadWorkLocData(),this.LoadLocData(),this.LoadTableData();var e=this.$router.currentRoute.path.slice(1,this.$router.currentRoute.path.length);this.loadElementsForRouter("elementlist",e)},methods:{LoadLocData:function(){var e=this;e.$ajax.request(e.axiosConfig("web.INMPersonComm","FindPartTimeLocList","RecQuery","parr$","nurseid$"+e.LoginId)).then(function(t){e.locdata=t.data.rows})},loadWorkLocData:function(){var e=this,t=e.axiosConfig("web.INMDataLimit","FindRoleLocList","RecQuery","nurseid$"+this.LoginId);e.$ajax.request(t).then(function(t){e.workLocStore=t.data.rows})},LoadTableData:function(){var e=this,t=e.searchform.Loc?e.searchform.Loc:"",a=e.searchform.WorkLoc?e.searchform.WorkLoc:"",r=e.searchform.Person?e.searchform.Person:"",o=e.searchform.StDate?e.searchform.StDate.Format("YYYY-MM-dd"):"",l=e.searchform.EndDate?e.searchform.EndDate.Format("YYYY-MM-dd"):"",n=(e.currentPage-1)*e.currentPageSize,i=e.currentPageSize;e.$ajax.request(e.axiosConfig("web.INMPersonComm","FindPartTimeData","Method","loc$"+t,"workLoc$"+a,"input$"+r,"stDate$"+o,"endDate$"+l,"nurseid$"+e.LoginId)).then(function(t){e.totalData=t.data.rows,e.tableData=t.data.rows.slice(n,n+i),e.totalCount=parseInt(t.data.results)})},Export:function(){var e=this;0!=e.totalData.length?a.e(327).then(function(){var t=a("qfDe").create_excel,r=n.Loading.service({fullscreen:!0,text:"拼命加载中..."}),o=new Array;new Array;t([{label:"姓名",prop:"PerName",width:50},{label:"工号",prop:"PerId",width:100},{label:"工作科室",prop:"WorkLoc",width:100},{label:"兼职科室",prop:"Loc",width:100},{label:"次数",prop:"Times",width:100},{label:"小时数",prop:"Hours",width:100},{label:"酬金",prop:"Salary",width:100}],e.totalData,o,"","export","兼职岗位认领统计列表","兼职岗位认领统计列表",new Array,r)}.bind(null,a)).catch(a.oe):e.$message({type:"warning",message:"无数据导出",showClose:!0,customClass:"warning_class"})},handleCurrentChange:function(e){this.currentPage=e.currentPage,this.LoadTableData()},handleSizeChange:function(e){this.currentPageSize=e,this.LoadTableData()},RowClick:function(e){this.DetailData=e.Detail,this.drawer=!0}}},u={render:function(){var e=this,t=e.$createElement,a=e._self._c||t;return a("div",{staticClass:"parttimestaic-panel"},[a("div",{staticClass:"top-tool-input"},[a("el-form",{ref:"searchform",attrs:{model:e.searchform,inline:!0}},[a("el-form-item",{attrs:{label:e.$t("menu.PartTimeNurseStatic.5nrnbhk8b7s0")}},[a("el-select",{staticStyle:{width:"140px"},attrs:{"default-first-option":"",filterable:"",clearable:"",placeholder:e.$t("menu.PartTimeNurseStatic.5nrnbhk9d7s0"),size:"mini"},model:{value:e.searchform.Loc,callback:function(t){e.$set(e.searchform,"Loc",t)},expression:"searchform.Loc"}},e._l(e.locdata,function(e){return a("el-option",{key:e.RowID,attrs:{label:e.LocDesc,value:e.RowID}})}),1)],1),e._v(" "),a("el-form-item",{attrs:{label:e.$t("menu.PartTimeNurseStatic.5ncy6erjll80")}},[a("el-select",{staticStyle:{width:"140px"},attrs:{"default-first-option":"",filterable:"",clearable:"",placeholder:e.$t("menu.PartTimeNurseStatic.5nrnbhk9d7s0"),size:"mini"},model:{value:e.searchform.WorkLoc,callback:function(t){e.$set(e.searchform,"WorkLoc",t)},expression:"searchform.WorkLoc"}},e._l(e.workLocStore,function(e){return a("el-option",{key:e.rw,attrs:{label:e.LocDesc,value:e.rw}})}),1)],1),e._v(" "),a("el-form-item",{staticClass:"statinurse",attrs:{label:e.$t("menu.PartTimeNurseStatic.5nrnbhkb68g0")}},[a("el-input",{staticStyle:{width:"100px"},attrs:{placeholder:e.$t("menu.PartTimeNurseStatic.5nrnbhkc1y80"),size:"mini"},model:{value:e.searchform.Person,callback:function(t){e.$set(e.searchform,"Person",t)},expression:"searchform.Person"}})],1),e._v(" "),a("el-form-item",{attrs:{label:e.$t("menu.PartTimeNurseStatic.5ncy6erjn0w0")}},[a("el-date-picker",{staticStyle:{width:"120px"},attrs:{type:"date",format:e.DateFormat,size:"mini"},model:{value:e.searchform.StDate,callback:function(t){e.$set(e.searchform,"StDate",t)},expression:"searchform.StDate"}})],1),e._v(" "),a("el-form-item",{attrs:{label:"-"}},[a("el-date-picker",{staticStyle:{width:"120px"},attrs:{type:"date",format:e.DateFormat,size:"mini"},model:{value:e.searchform.EndDate,callback:function(t){e.$set(e.searchform,"EndDate",t)},expression:"searchform.EndDate"}})],1),e._v(" "),a("hgbutton",{attrs:{type:"default",styleCode:e.styleCode,icon:"nm-icon-w-find"},on:{click:e.LoadTableData}},[e._v(e._s(e.$t("menu.PartTimeNurseStatic.5nrnbhkc3q40")))]),e._v(" "),a("hgbutton",{attrs:{type:"default",styleCode:e.styleCode,icon:"nm-icon-w-export"},on:{click:e.Export}},[e._v(e._s(e.$t("menu.PartTimeNurseStatic.5nrnbhkc44g0")))])],1)],1),e._v(" "),a("div",{staticClass:"top-tool-table"},[a("el-table",{attrs:{data:e.tableData,height:e.styleCode?e.Height-93:e.Height-91,border:e.styleCode,"header-cell-style":e.headerCellFontWeight,"highlight-current-row":""},on:{"row-click":e.RowClick}},[a("el-table-column",{attrs:{type:"index",width:"40",align:"center"}}),e._v(" "),a("el-table-column",{attrs:{prop:"PerName","show-overflow-tooltip":"",width:"150",label:e.$t("menu.PartTimeNurseStatic.5nrnbhkc1y80")}}),e._v(" "),a("el-table-column",{attrs:{prop:"PerId","show-overflow-tooltip":"",width:"150",label:e.$t("menu.PartTimeNurseStatic.5nrnbhkeb400")}}),e._v(" "),a("el-table-column",{attrs:{prop:"WorkLoc","show-overflow-tooltip":"",width:"150",label:e.$t("menu.PartTimeNurseStatic.5ncy6erjll80")}}),e._v(" "),a("el-table-column",{attrs:{prop:"Loc","show-overflow-tooltip":"",width:"100",label:e.$t("menu.PartTimeNurseStatic.5nrnbhk8b7s0")}}),e._v(" "),a("el-table-column",{attrs:{prop:"Times","show-overflow-tooltip":"",width:"100",label:e.$t("menu.PartTimeNurseStatic.5nrnbhkgpuo0")}}),e._v(" "),a("el-table-column",{attrs:{prop:"Hours","show-overflow-tooltip":"",width:"100",label:e.$t("menu.PartTimeNurseStatic.5nrnbhkhnlg0")}}),e._v(" "),a("el-table-column",{attrs:{prop:"Salary",label:e.$t("menu.PartTimeNurseStatic.5ncy6erjrcs0")}})],1),e._v(" "),a("hgpagination",{attrs:{styleCode:e.styleCode,sizes:[20,40,50,100],totalCount:e.totalCount,pageNumber:e.currentPage,pageSize:e.currentPageSize},on:{changePage:e.handleCurrentChange,getPageSize:e.handleSizeChange}})],1),e._v(" "),a("el-drawer",{attrs:{title:e.$t("menu.PartTimeNurseStatic.5nrnbhkil600"),visible:e.drawer,size:"50%","with-header":!1},on:{"update:visible":function(t){e.drawer=t}}},[[a("el-table",{attrs:{title:e.$t("menu.PartTimeNurseStatic.5ncy6erjt5s0"),data:e.DetailData,height:e.Height,"header-cell-style":e.headerCellFontWeight,border:e.styleCode,"highlight-current-row":""}},[a("el-table-column",{attrs:{type:"index",width:"70"}}),e._v(" "),a("el-table-column",{attrs:{label:e.$t("menu.PartTimeNurseStatic.5ncy6erju0g0"),prop:"PostName"}}),e._v(" "),a("el-table-column",{attrs:{label:e.$t("menu.PartTimeNurseStatic.5ncy6erjucs0"),prop:"Date"}}),e._v(" "),a("el-table-column",{attrs:{label:e.$t("menu.PartTimeNurseStatic.5nrnbhkhnlg0"),prop:"Hour"}}),e._v(" "),a("el-table-column",{attrs:{label:e.$t("menu.PartTimeNurseStatic.5ncy6erjuwg0"),prop:"Salary"}})],1)]],2)],1)},staticRenderFns:[]};var m=a("VU/8")(c,u,!1,function(e){a("7QLb")},null,null);t.default=m.exports}});