
function InitExpressionEditorEvent(obj) {
	obj.LoadEvent = function(args)
  {
  	obj.MethodPackageMgr = ExtTool.StaticServerObject("DHCMed.CCService.MethodPackageSrv");
  	
  	window.setTimeout(
	  	function(){
	  		objTxtExp = document.getElementById("txtExpression");
				objTxtExp.attachEvent("Change",txtExpression_Change);
				objTxtExp.attachEvent("DblClick", txtExpression_DoubleClick);
			},
			3000
		);
  	
  };
	obj.btnSymbolGreat_click = function()
	{
		InsertText(">");
	};
	obj.btnSymbolGreatEqual_click = function()
	{
		InsertText(">=");
	};
	obj.btnSymbolLess_click = function()
	{
		InsertText("<");
	};
	obj.btnSymbolLessEqual_click = function()
	{
		InsertText("<=");
	};
	obj.btnSymbolAdd_click = function()
	{
		InsertText("+");
	};
	obj.btnSymbolMinus_click = function()
	{
		InsertText("-");
	};
	obj.btnSymbolMulti_click = function()
	{
		InsertText("*");
	};
	obj.btnSymbolDivide_click = function()
	{
		InsertText("/");
	};
	obj.btnSymbolAnd_click = function()
	{
		InsertText(".and.");
	};
	obj.btnSymbolOr_click = function()
	{
		InsertText(".or.");
	};
	obj.btnSymbolLeft_click = function()
	{
		InsertText("(");
	};
	obj.btnSymbolRight_click = function()
	{
		InsertText(")");
	};
	obj.tvPackage_dblclick = function(objNode)
	{
		var strID = objNode.id;
		var arry = strID.split("-");
		var strLibName = obj.MethodPackageMgr.GetLibName(arry[1]);
		InsertText(strLibName);
	};
/*Window1新增代码占位符*/}

