<!-- DHC.WMR.InputFP.Shortcuts.JS -->
///Creator:wangcs
///Description:病案编目快捷键操作
///CreateDate:2011-11-29
  /*
    t["SaveToGrid"]="保存回列表[ALT+S]";
	t["AddFromHis"]="添加[ALT+A]";
	t["strDel"]="删除[ALT+X]";
	t["strNextPage"]="下一页[ALT+N]";
	t["strSave"]="保存[ALT+G]";
	alert(t["strSave"]);
  */  
  
function InitShortcutsEvent(){
	
    //快捷键ALT+S，保存回列表
	//快捷键ALT+G，保存疾病手术编码
	//快捷键ALT+D，删除一条疾病手术编码
	//快捷键ALT+A，增加一条疾病手术编码
	var objDocumentKeyMap = new Ext.KeyMap(
		Ext.get(document)
		,[
		{
		    key:[83]  //S
		    ,fn: SaveDataToGridKeyMap
		    ,shift: false
		    ,ctrl: false
			,alt: true
		    ,scope: this
		}
		,{
		    key:[71]  //G
		    ,fn: btnSaveOnClick
		    ,shift: false
		    ,ctrl: false
			,alt: true
		    ,scope: this
		},
		{
		    key:[88]   //D
		    ,fn:DelData
		    ,shift:false
		    ,ctrl:false
		    ,alt:true
		    ,scope:this
		}
		,{
		    key:[65]   //A
		    ,fn:AddDataFromHis
		    ,shift:false
		    ,ctrl:false
		    ,alt:true
		    ,scope:this
		}
		,{
		    key:[78]   //N
		    ,fn:TabKeyMap
		    ,shift:false
		    ,ctrl:false
		    ,alt:true
		    ,scope:this
		}
		]
		
	);
}
//在四个页签间切换
function TabKeyMap(){
    if (objTabs.activeTab.title==t["strBaseFromTitle"]) {
         btnNextPageOnClick();
    }
    else if (objTabs.activeTab.title==t["strSummaryGridTitle"]){ 
        objTabs.activate(objDisTab);
        cboDiseaseICD.focus();
    }
    else if (objTabs.activeTab.title==t['strDiseaseGridTitle']) 
    {
       objTabs.activate(objOpeTab);
       cboOperationICD.focus();
    }
    else if (objTabs.activeTab.title==t["strOperationGridTitle"]) 
    {
       objTabs.activate(objBaseInfo);
       btnNextPage.focus();
    }
}
//保存回列表
function SaveDataToGridKeyMap(){
	  	if (objTabs.activeTab.title==t['strDiseaseGridTitle']){
	  		GridPanelTBarButtonHandler(objGridDisease,t["SaveToGrid"]);
  		}
  		if (objTabs.activeTab.title==t['strOperationGridTitle']){
  			GridPanelTBarButtonHandler(objGridOperation,t["SaveToGrid"]);
  		}
}
//删除一行
function DelData()
{
    if(objTabs.activeTab.title==t['strDiseaseGridTitle'])
    {
       GridPanelTBarButtonHandler(objGridDisease,t["strDel"]);
       //RemoveDisease();
       //ClearDiseaseTableInputControl();
       SelectNextRow(objGridDisease);
    }
    if(objTabs.activeTab.title==t['strOperationGridTitle'])
    {
    	GridPanelTBarButtonHandler(objGridOperation,t["strDel"]);
        SelectNextRow(objGridOperation);
        //ClearOperationTableInputControl(false);
        //cboOperationLCR.focus();
    }
}
//执行GridPanel的tbar的按钮事件
function GridPanelTBarButtonHandler(gridPanel,buttonText){
	    var GPTBar=gridPanel.getTopToolbar();
        var TBarItems=GPTBar.items.items;
        Ext.each(TBarItems,function(item){
        		if (item.text==buttonText){
        			item.initialConfig.handler();
        		}
        	},null);
}
//增加一条记录
function AddDataFromHis()
{
    if(objTabs.activeTab.title==t['strDiseaseGridTitle'])
    {
        GridPanelTBarButtonHandler(objGridDisease,t["AddFromHis"]);
    }
    if(objTabs.activeTab.title==t['strOperationGridTitle'])
    {
    	GridPanelTBarButtonHandler(objGridOperation,t["AddFromHis"]);
    }
}
//选中下一行
function SelectNextRow(objGrid){
    var nextInd=NextRowIndPos(objGrid);
    objGrid.getSelectionModel().selectRow(nextInd,true);
}
//选中下一行的Index
function NextRowIndPos(objGrid){
   var objRec=GetGridSelectedData(objGrid);
   var objStore=objGrid.getStore();
   var indPos=0;
   if (objRec!=null){
       indPos=objStore.indexOf(objRec);
       var count=objStore.getStore().getCount();
       var indPos=indPos+1;    //下一行
       if (indPos>count-1){    //判断是否是最后一行
           indPos=count-1;
       }
   }
   return indPos;
}
//选中上一行
function SelectUpRow(objGrid){
    var upInd=UpRowIndPos(objGrid);
    objGrid.getSelectionModel().selectRow(upInd,true);
}
//选中上一行的Index
function UpRowIndPos(objGrid){
   var objRec=GetGridSelectedData(objGrid);
   var objStore=objGrid.getStore();
   var indPos=0
   if (objRec!=null){
      indPos=objStore.indexOf(objRec);
      if (indPos-1>0){
         indPos=indPos-1;       //上一行
      }
   }
   return indPos;
}
function ShowRec(objRec){
    if(objTabs.activeTab.title==t['strDiseaseGridTitle'])
    {
        
        
    }
    if(objTabs.activeTab.title==t['strOperationGridTitle'])
    {
        AddOpeFromHis();
    }
}
//选中一个下拉框
function SelectInputText(cboObj){
    var txtRawValue=cboObj.getRawValue();
    cboObj.selectText(0,txtRawValue.length);
	cboObj.focus();
}
