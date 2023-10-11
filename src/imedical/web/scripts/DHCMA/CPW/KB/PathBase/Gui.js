//页面Gui
var obj = new Object();
function InitKBaseWin(){
	
    $.parser.parse(); 
	var HospID=session['DHCMA.HOSPID']
	if (typeof HISUIStyleCode === 'undefined'){
		$("#dataPng").attr("src","../images/no_data.png")
	}else{
		if (HISUIStyleCode=="lite"){
			$("#dataPng").attr("src","../images/no_data_lite.png")
			$("#cboYear").attr("style","width:95px;float:left;height:45px;border-radius:5px 0 0 5px;border-right:0px;background-image:url();border-color:#339EFF")
			$("#cboType").attr("style","width:128px;float:left;height:45px;border-right:0px;background-image:url();border-color:#339EFF")
			$("#cboGC").attr("style","width:128px;float:left;height:45px;border-right:0px;background-image:url();border-color:#339EFF")
			$("#textKey").attr("style","width:337px;float:left;height:43px;border-right:0px;background-image:url();border-color:#339EFF")
		}else{
			$("#dataPng").attr("src","../images/no_data.png")
		}
	}
	var data=$cm({
			ClassName:'DHCMA.CPW.BTS.PathTypeSrv',
			QueryName:'QryPathType',
			rows:1000
		},false)
	if (data == "") return;
	var len=data.rows.length
	for (var i = 0; i < len; i++) {
　　　　$("#cboType").append("<option>"+data.rows[i].BTDesc+"</option>");
　　}
	var YearList=$cm({
			ClassName:'DHCMA.CPW.KBS.PathBaseSrv',
			QueryName:'QryPBYear',
			rows:1000
		},false)
	if (YearList == "") return;
	var len=YearList.rows.length
	for (var i = 0; i < len; i++) {
　　　　$("#cboYear").append("<option>"+YearList.rows[i].BTDesc+"</option>");
　　}
	InitKBaseWinEvent(obj);	
	return obj;
}