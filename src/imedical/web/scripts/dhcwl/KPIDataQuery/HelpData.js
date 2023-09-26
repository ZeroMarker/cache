(function(){
	Ext.ns("dhcwl.BDQ.HelpData");
})();
///描述: 		查询对象
///编写者：		WZ
///编写日期: 		2016-11
dhcwl.BDQ.HelpData=function(pObj){
	var helpDataWin = new Ext.Window({
        width:800,
		height:600,
		resizable:true,
		//closable : false,
		title:'操作说明',
		modal:true,
		html:'<iframe id="runqianRpt" width=100% height=100% '+
			'src="dhcwl/basedataquery/helpData.htm"></iframe>'
	});	


	function OnCancel() {
			helpDataWin.close();
	}
 

	this.init=function(inP) {

	}
	
	this.getHelpDataWin=function() {
		return helpDataWin;
	}
	
	
	this.show=function() {
		helpDataWin.show();
	}


}

