<!-- DHC.WMR.InputFP.Shortcuts.JS -->
///Creator:wangcs
///Description:������Ŀ��ݼ�����
///CreateDate:2011-11-29
  /*
    t["SaveToGrid"]="������б�[ALT+S]";
	t["AddFromHis"]="���[ALT+A]";
	t["strDel"]="ɾ��[ALT+X]";
	t["strNextPage"]="��һҳ[ALT+N]";
	t["strSave"]="����[ALT+G]";
	alert(t["strSave"]);
  */  
  
function InitShortcutsEvent(){
	
    //��ݼ�ALT+S��������б�
	//��ݼ�ALT+G�����漲����������
	//��ݼ�ALT+D��ɾ��һ��������������
	//��ݼ�ALT+A������һ��������������
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
//���ĸ�ҳǩ���л�
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
//������б�
function SaveDataToGridKeyMap(){
	  	if (objTabs.activeTab.title==t['strDiseaseGridTitle']){
	  		GridPanelTBarButtonHandler(objGridDisease,t["SaveToGrid"]);
  		}
  		if (objTabs.activeTab.title==t['strOperationGridTitle']){
  			GridPanelTBarButtonHandler(objGridOperation,t["SaveToGrid"]);
  		}
}
//ɾ��һ��
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
//ִ��GridPanel��tbar�İ�ť�¼�
function GridPanelTBarButtonHandler(gridPanel,buttonText){
	    var GPTBar=gridPanel.getTopToolbar();
        var TBarItems=GPTBar.items.items;
        Ext.each(TBarItems,function(item){
        		if (item.text==buttonText){
        			item.initialConfig.handler();
        		}
        	},null);
}
//����һ����¼
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
//ѡ����һ��
function SelectNextRow(objGrid){
    var nextInd=NextRowIndPos(objGrid);
    objGrid.getSelectionModel().selectRow(nextInd,true);
}
//ѡ����һ�е�Index
function NextRowIndPos(objGrid){
   var objRec=GetGridSelectedData(objGrid);
   var objStore=objGrid.getStore();
   var indPos=0;
   if (objRec!=null){
       indPos=objStore.indexOf(objRec);
       var count=objStore.getStore().getCount();
       var indPos=indPos+1;    //��һ��
       if (indPos>count-1){    //�ж��Ƿ������һ��
           indPos=count-1;
       }
   }
   return indPos;
}
//ѡ����һ��
function SelectUpRow(objGrid){
    var upInd=UpRowIndPos(objGrid);
    objGrid.getSelectionModel().selectRow(upInd,true);
}
//ѡ����һ�е�Index
function UpRowIndPos(objGrid){
   var objRec=GetGridSelectedData(objGrid);
   var objStore=objGrid.getStore();
   var indPos=0
   if (objRec!=null){
      indPos=objStore.indexOf(objRec);
      if (indPos-1>0){
         indPos=indPos-1;       //��һ��
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
//ѡ��һ��������
function SelectInputText(cboObj){
    var txtRawValue=cboObj.getRawValue();
    cboObj.selectText(0,txtRawValue.length);
	cboObj.focus();
}
