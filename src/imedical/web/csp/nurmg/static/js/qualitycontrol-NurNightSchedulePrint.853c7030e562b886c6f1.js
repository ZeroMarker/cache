webpackJsonp([197],{OYGT:function(t,e){},"a6/g":function(t,e,a){"use strict";Object.defineProperty(e,"__esModule",{value:!0});var r=a("Dd8w"),n=a.n(r),c=a("s5sJ"),s=a("XlQt"),o=a("NYxO"),i={components:{hgbutton:s.default},computed:n()({},Object(o.b)(["styleCode"])),id:"NurNightSchedulePrint",props:["activetitle","flag","taskid","taskDate","checkerName"],data:function(){return{printTitle:"",checkwards:[],TableData:[],checkBasicData:[],checkDate:"",checkPerson:"",total:{desc:"合计"},scoreType:"",scoreTypeSub:"",Deepth:1,ShowRemark:!1}},methods:{PrintSchdule:function(){var t=document.getElementById("schduleprint").innerHTML,e=Object(c.a)();e.PRINT_INIT(""),e.SET_PRINT_PAGESIZE(2,"210mm","297mm","A4"),e.ADD_PRINT_HTM("0.1cm","0.1cm","RightMargin:0.1cm","BottomMargin:0.1cm",t),e.SET_SHOW_MODE("LANDSCAPE_DEFROTATED",1),e.PREVIEW(),this.PrintWhiteFlag=!1},GetFatherShow:function(t){var e=this;return!t.some(function(t){return 1!=e.TableData.find(function(e){return e.SubSort==t}).FatherShow})},GetFatherRowSpan:function(t){return t=t.substring(0,t.lastIndexOf(".")),this.TableData.find(function(e){return e.SubSort==t}).RowSpan},GetFatherDesc:function(t){return t=t.substring(0,t.lastIndexOf(".")),this.TableData.find(function(e){return e.SubSort==t}).SubItem},GetSchduleData:function(){var t=this;t.checkwards=new Array,t.$ajax.request(t.axiosConfig("web.INMQualControlComm","GetCheckPanes","Method","taskid$"+t.taskid)).then(function(e){if(e.data instanceof Object){t.checkwards=e.data.CheckWard,t.checkBasicData=e.data.CheckBasic;for(var a=function(a){var r=e.data.TaskPanel[a];t.activetitle==r.Name+"「"+r.ScoreType&&(t.printTitle=r.Title,t.scoreType=r.ScoreType,t.scoreTypeSub=r.ScoreTypeSub,t.Deepth=isNaN(parseInt(r.Deepth))?1:parseInt(r.Deepth),t.flag||(t.checkDate=r.checkDate,t.checkPerson=r.checkPerson),2!=r.ScoreType&&2==r.ScoreTypeSub&&r.QualSubItems.forEach(function(e){t.checkwards.forEach(function(t){if(e["c"+t.WardId]){var a=e.CheckMenu.split(","),r="";e["c"+t.WardId].split(",").forEach(function(t,e){t&&(r=r?r+","+a[e].split("@")[0]+":"+t:a[e].split("@")[0]+":"+t)}),e["ctoshow"+t.WardId]=r}else e["ctoshow"+t.WardId]=""})}),t.TableData=r.QualSubItems,t.checkwards.forEach(function(e){var a=e.WardId,n=0,c=0,s=new Array(3).fill(0);if(t.TableData.forEach(function(e){"headnur"!=e.QualSubId&&1!=e.HasChild&&(2==r.ScoreType?(isNaN(t.total["c"+a])?t.total["c"+a]=0:t.total["c"+a]=parseFloat(t.total["c"+a]),t.total["c"+a]=t.total["c"+a]+(isNaN(parseFloat(e["c"+a]))?0:parseFloat(e["c"+a]))):1==r.ScoreTypeSub?"√"==e["c"+a]?n+=1:"×"==e["c"+a]&&(c+=1):2==r.ScoreTypeSub&&e["c"+a]&&e["c"+a].split(",").forEach(function(t,e){s[e]+=isNaN(parseInt(t))?0:parseInt(t)}))}),2!=r.ScoreType&&1==r.ScoreTypeSub)t.total["c"+a]=n+c==0?"100%":(n/(n+c)*100).toFixed(2)+"%";else if(2!=r.ScoreType&&2==r.ScoreTypeSub){var o=s.reduce(function(t,e){return t+e}),i=[1,0,0],l=s.map(function(t,e){return t*i[e]}).reduce(function(t,e){return t+e});t.total["c"+a]=0==o?"100%":100*(l/o).toFixed(2)+"%"}}))},r=0;r<e.data.TaskPanel.length;r++)a(r)}else t.$message({type:"error",message:"获取检查单失败!",showClose:!0,customClass:"error_class"})}).catch(function(e){t.$message({type:"error",message:"获取检查单失败!",showClose:!0,customClass:"error_class"})})},LoadQualParram:function(){var t=this,e=this.axiosConfig("web.INMSetComm","FindParamSubList","RecQuery","parr$^QualSetting");this.$ajax.request(e).then(function(e){e.data instanceof Object&&e.data.rows.length>0&&e.data.rows.filter(function(t){return"ShowRemark"==t.SubCode}).map(function(e){return t.ShowRemark="Y"==e.SubValue}),t.GetSchduleData()}).catch(function(e){t.$message({type:"error",message:"获取参数失败",showClose:!0,customClass:"error_class"})})}},created:function(){this.LoadQualParram()}},l={render:function(){var t=this,e=t.$createElement,a=t._self._c||e;return a("div",{staticClass:"night-scheule-print"},[a("div",{staticClass:"print-button",attrs:{align:"right"}},[a("hgbutton",{attrs:{type:"default",styleCode:t.styleCode,icon:"nm-icon-w-print"},on:{click:t.PrintSchdule}},[t._v(t._s(t.$t("menu.NurNightSchedulePrint.5nrnbrpi0ks0")))])],1),t._v(" "),a("div",{ref:"schduleprint",attrs:{id:"schduleprint"}},[a("div",[a("table",{staticClass:"table-to-print",attrs:{id:"TableToPrint",cellspacing:"0",cellpadding:"0"}},[a("caption",[a("div",[t._v(t._s(t.printTitle))]),a("br"),t._v(" "),a("span",[t._v(t._s(t.$t("menu.NurNightSchedulePrint.5ncy6kld2fs0")+t.checkerName+t.$t("menu.NurNightSchedulePrint.5ncy6kldzgk0")+(t.taskDate instanceof Date?t.taskDate.Format("YYYY-MM-dd"):"")))])]),t._v(" "),a("thead",[a("tr",[a("th",{attrs:{colspan:t.Deepth,rowspan:"2"}},[t._v(t._s(t.$t("menu.NurNightSchedulePrint.5nrnbrpi3y40")))]),t._v(" "),a("th",{staticStyle:{"text-align":"center"},attrs:{colspan:t.checkwards.length*(t.ShowRemark?2:1)}},[t._v(t._s(t.$t("menu.NurNightSchedulePrint.5nrnbrpi4gs0")))])]),t._v(" "),a("tr",t._l(t.checkwards,function(e,r){return a("th",{key:r,attrs:{colspan:t.ShowRemark?2:1}},[t._v(t._s(e.WardDesc))])}),0)]),t._v(" "),a("tbody",[t._l(t.checkBasicData,function(e,r){return a("tr",{key:"basic"+r},[0==r&&t.Deepth>1?a("td",{attrs:{rowspan:t.checkBasicData.length}},[t._v(t._s(t.$t("menu.NurNightSchedulePrint.5nrnbrpi5so0")))]):t._e(),t._v(" "),a("td",{attrs:{colspan:t.Deepth>1?t.Deepth-1:1}},[t._v(t._s(e.Item))]),t._v(" "),t._l(t.checkwards,function(r,n){return a("td",{key:n,attrs:{colspan:t.ShowRemark?2:1,align:"left"}},[t._v(t._s(t.flag?"":e["b"+r.WardId]))])})],2)}),t._v(" "),t._l(t.TableData,function(e,r){return[0==e.HasChild?a("tr",{key:"item"+r},[t._l(e.Roots,function(r,n){return[1==e.FatherShow&&t.GetFatherShow(e.Roots.slice(n,-1))?a("td",{key:n,attrs:{rowspan:t.GetFatherRowSpan(r)}},[t._v(t._s(t.GetFatherDesc(r)))]):t._e()]}),t._v(" "),a("td",{attrs:{colspan:t.Deepth-e.SubSort.split(".").length+2}},[t._v(t._s(e.SubItem))]),t._v(" "),t._l(t.checkwards,function(n,c){return[a("td",{key:"score"+c,attrs:{colspan:r==t.TableData.length-1&&t.ShowRemark?2:1,align:"left"}},[t._v(t._s(t.flag?"":2!=t.scoreType&&2==t.scoreTypeSub?e["ctoshow"+n.WardId]:e["c"+n.WardId]))]),t._v(" "),r!=t.TableData.length-1&&t.ShowRemark?a("td",{key:"remark"+c,attrs:{align:"left"}},[t._v(t._s(t.flag?"":e["r"+n.WardId]))]):t._e()]})],2):t._e()]}),t._v(" "),a("tr",[a("td",{attrs:{colspan:t.Deepth}},[t._v(t._s(t.total.desc))]),t._v(" "),t._l(t.checkwards,function(e,r){return a("td",{key:r,attrs:{colspan:t.ShowRemark?2:1,align:"left"}},[t._v(t._s(t.flag||!t.total["c"+e.WardId]?"":t.total["c"+e.WardId]))])})],2)],2)])])])])},staticRenderFns:[]};var u=a("VU/8")(i,l,!1,function(t){a("OYGT")},null,null);e.default=u.exports}});