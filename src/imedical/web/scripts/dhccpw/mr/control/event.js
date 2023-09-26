
function InitviewScreenEvent(obj) {
	obj.LoadEvent = function(args)
	{
		obj.btnQuery.on("click", obj.btnQuery_click, obj);
	};

	obj.btnQuery_click = function()
	{
		//Add By LiYang 2011-05-21 //Fix Bug 56 '临床路径实施管理--临床路径监控-清空路径一项后再查询查询不到信息
		if(obj.cboLoc.getRawValue() == "")
			obj.cboLoc.clearValue(); 
		if(obj.cboPathWayDic.getRawValue() == "")
			obj.cboPathWayDic.clearValue(); 			
		
		
		
			obj.gridResultStore.removeAll();
			var param = new Object();
			param.ClassName = 'web.DHCCPW.MR.CtrControlMain';
			param.QueryName = 'QryCtl';
			param.Arg1 = obj.cboLoc.getValue();
			param.Arg2 = obj.cboPathWayDic.getValue();
			param.Arg3 = "";
			param.Arg4 = obj.dtFromDate.getRawValue();
			param.Arg5 = obj.dtToDate.getRawValue();
			param.ArgCnt = 5;
			//window.alert("PathWayDic:" + obj.cboPathWayDic.getValue());
			//window.alert("Loc:" + obj.cboLoc.getValue());
			//window.alert("FromDate:" + obj.dtFromDate.getRawValue());
			//window.alert("ToDate:" + obj.dtToDate.getRawValue());
			var objConfig = {
				params : param	
			};
			obj.gridResultStore.load(objConfig);
	}

	obj.gridResult_rowdblclick = function(objGrid, rowIndex)
	{
		var objRec = obj.gridResultStore.getAt(rowIndex);
		var PathWayVerID = objRec.get("PathWayVerID");
		var Paadm = objRec.get("Paadm");
		var PathWayID = objRec.get("PathWayID");
		var RegNo = objRec.get("RegNo");
		var PatientName = objRec.get("PatientName");
		var PathName = objRec.get("PathName");
		var objWin = new Ext.Window({
			title : "详细信息【" + "登记号：" + RegNo + "，姓名：" + PatientName + "，路径名：" + PathName + "】",
			modal : true,
			html : '<iframe border=0 src="./dhccpw.mr.controldetail.csp?Adm=' + Paadm + 
				'&VersionID=' + PathWayVerID + '&PathWayID=' + PathWayID + '" height="100%" width="100%"/>',
			height : 450,
			width : 850,
			maximizable : true,
			maximized : true,
			layout : 'fit'
			/*,
			buttons : [
				
				{
					text : '关闭'
					,handler: function()
					{
						objWin.close();
					}
				}
				
			]*/
		})
		objWin.show();
	}
}

