
function InitDtlWindowEvent(obj)
{
	obj.LoadEvent = function(args)
	{
		obj.btnDtlExport.on("click", obj.btnDtlExport_OnClick, obj);
	}
	obj.btnDtlExport_OnClick = function(){
		var strFileName="�ٴ�·���±���ϸ";
		var objExcelTool=Ext.dhcc.DataToExcelTool;
		objExcelTool.ExprotGrid(obj.DtlResultGridPanel,strFileName);
	}
}

//function AnalysisDtlHeader(aCPWDID,aDateFrom,aDateTo,aAnalysisType,aLoc)
//	Modified by zhaoyu 2012-11-23 �ٴ�·���±���ϸ���⴫��
function AnalysisDtlHeader(aCPWDID,aDateFrom,aDateTo,aAnalysisType,aLoc,aAnalysisRawValue,aCPWDicDesc)
{
	//var objDtlWindow = new InitDtlWindow(aDateFrom,aDateTo,aCPWDID,aAnalysisType,aLoc);
	//	Modified by zhaoyu 2012-11-23 �ٴ�·���±���ϸ���⴫��
	var objDtlWindow = new InitDtlWindow(aDateFrom,aDateTo,aCPWDID,aAnalysisType,aLoc,aAnalysisRawValue,aCPWDicDesc);
    objDtlWindow.DtlWindow.show();
	//var numTop=(screen.availHeight-objDtlWindow.DtlWindow.height)/2;
	//var numLeft=(screen.availWidth-objDtlWindow.DtlWindow.width)/2;
	//objDtlWindow.DtlWindow.setPosition(numLeft,numTop);
    ExtDeignerHelper.HandleResize(objDtlWindow);
}