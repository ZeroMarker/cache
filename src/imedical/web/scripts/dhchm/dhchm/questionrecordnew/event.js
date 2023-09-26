
function InitViewport1Event(obj){
    obj.LoadEvent = function(args){
        obj.GridPanel1Store.load({
            params: {
                start: 0,
                limit: obj.bbar.pageSize
            }
        });
        obj.StartDate.focus(true, 3);
    };
    obj.BFind_click = function(){
        obj.GridPanel1Store.load({
            params: {
                start: 0,
                limit: obj.bbar.pageSize
            }
        });
		
        //callback :function(){obj.GridPanel1.getSelectionModel().selectFirstRow();}
    };
    obj.TabChange = function(tabPanel, activePanel){
        if (!activePanel) 
            return;
		
        var ID = activePanel.getId();
        var Type = ID.substring(1, 2);
        if (Type == "Q") {
            obj.GetHisResult.setVisible(true);
        }
        else {
            obj.GetHisResult.setVisible(false);
        }
    };
	/*
	 obj.Close_click = function(){
		 
		 alert(2)
		 
	 }
	*/
    obj.GetHisResult_click = function(){
        var formPanel = obj.FormPanel3.getActiveTab();
        if (!formPanel) 
            return;
        var baseForm = formPanel.getForm();
        var panelID = formPanel.id;
        var Type = panelID.substring(1, 2);
        if (Type != "Q") {
            ExtTool.alert("��ʾ", "�����ʾ������ܻ�ȡ")
            return;
        }
        var ID = panelID.substring(1, panelID.length);
        var EID = ID.substring(1, ID.length);
        var rStr = obj.Method.GetQuestionStatus(EID, Type, "U");
        if (rStr != "") {
            ExtTool.alert("��ʾ","����ʧ�ܣ� "+ rStr);
            return;
        }
        var rStr = obj.Method.GetHisResult(EID);
        var Char1 = String.fromCharCode(1);
        var rArray = rStr.split(Char1);
        var flag = rArray[0];
        if (flag < 0) {
            ExtTool.alert("��ʾ", rArray[1])
            return;
        }
        var resultStr = rArray[1];
        var resultJson = Ext.decode(resultStr);
        var rec = new Ext.data.Record(resultJson);
        baseForm.loadRecord(rec);
    };
	
	
	
	
	
    obj.GridPanel1_rowclick = function(objGrid, row, e){
		//alert(row)
        var record = objGrid.getStore().getAt(row);
        alert(obj.RecordID)
        alert(record.get("ID"))
        if (obj.RecordID == record.get("ID")) 
            return;
        if (obj.FormPanel3.getActiveTab()) {
	        //alert(2)
            obj.FormPanel3.removeAll(true);
        }
        //alert(record.get("ID"));
        obj.RecordID = record.get("ID");
        obj.TreeLoader.baseParams.Arg1 = obj.RecordID;
        obj.TreePanel.loader = obj.TreeLoader;
        obj.TreeLoader.load(obj.TreePanel.getRootNode());
		
        obj.TreePanel.expandAll();
        //obj.TreePanel.getRootNode().expanded=true;
    };
	
	
	
    obj.showProgress=function(){
    	Ext.MessageBox.wait('Loadng...........', '�����У���ȴ�');
      Ext.MessageBox.updateProgress(1);
          
      var delay=new Ext.util.DelayedTask(obj.Save_click);
      delay.delay(500);
}
    obj.Save_click = function(){
    	 
        var formPanel = obj.FormPanel3.getActiveTab();
        if (!formPanel) 
            return;
        var baseForm = formPanel.getForm();
        /*
         if (!baseForm.isValid()){
         ExtTool.alert("��ʾ","����¼������")
         return;
         }
         */
        var panelID = formPanel.id;
        var Type = panelID.substring(1, 2);
        var ID = panelID.substring(1, panelID.length);
        var EID = ID.substring(1, ID.length);
        var rStr = obj.Method.GetQuestionStatus(EID, Type, "U");
        //alert(rStr+'-'+Type+'-'+ID+'-'+EID);
        if (rStr != "") {
            ExtTool.alert("��ʾ","����ʧ�ܣ� "+ rStr);
            return;
        }
		
        var Char1 = String.fromCharCode(1); 
        var Char2 = String.fromCharCode(2);
        var resultStr = "";
		//alert(Type)
        if (Type != "T") {
            //textfield,numberfield,datefield,combo
            var pp = formPanel.findByType('textfield');
            var j = pp.length;
            for (var i = 0; i < j; i++) {
            
                if (!pp[i].isValid()) {
                    Ext.MessageBox.show({
                        title: '��ʾ',
                        msg: pp[i].fieldLabel + '����Ϊ��',
                        buttons: Ext.Msg.OK,
                        fn: function(){
                            pp[i].focus();
                        }
                    });
                    return false;
                }
                var id = pp[i].getId();
               
                id = id.split("^")[1];
                var value = pp[i].getValue();
                if ((pp[i].isXType('datefield')) && (value != "")) {
                    value = value.format(ExtToolSetting.DateFormatString);
                }
                if (resultStr == "") {
                    resultStr = id + Char2 + value;
                }
                else {
                    resultStr = resultStr + Char1 + id + Char2 + value;
                }
            };
            //checkbox radion;
            var pp = formPanel.findByType('checkbox');
            var j = pp.length;
            for (var i = 0; i < j; i++) {
              
                var id = pp[i].getId();
                id = id.split("^")[1];
                var value = pp[i].getValue();
                var string = "N";
                if (value) {
                    string = "Y";
                }
                if (resultStr == "") {
                    resultStr = id + Char2 + string;
                }
                else {
                    resultStr = resultStr + Char1 + id + Char2 + string;
                }
            };
            
                    /*
             //var objJson = baseForm.getValues();
             var objJson = baseForm.getFieldValues(true);
             for (var oneKey in objJson) {
             oneValue = objJson[oneKey];
             if (oneValue == obj.InputInfo)
             continue;
             if (resultStr == "") {
             resultStr = oneKey + Char2 + oneValue;
             }
             else {
             resultStr = resultStr + Char1 + oneKey + Char2 + oneValue;
             }
             }*/
        }
        else { 
        	
        //------cxr----------------------------------------------
        var myRecord = new Ext.data.Record.create([{
        name: 'checked',
        mapping: 'checked'
    }, {
        name: 'ID',
        mapping: 'ID'
    }, {
        name: 'QMTCMedicalTipsDR',
        mapping: 'QMTCMedicalTipsDR'
    }, {
        name: 'QMTDesc',
        mapping: 'QMTDesc'
    }, {
        name: 'QMTDetail',
        mapping: 'QMTDetail'
    }, {
        name: 'QMTType',
        mapping: 'QMTType'
    }, {
        name: 'QMTRemark',
        mapping: 'QMTRemark'
    }, {
        name: 'QMTUpdateDate',
        mapping: 'QMTUpdateDate'
    }, {
        name: 'QMTUpdateTime',
        mapping: 'QMTUpdateTime'
    }, {
        name: 'QMTUpdateUsr',
        mapping: 'QMTUpdateUsr'
    }, {
        name: 'SSUSRName',
        mapping: 'SSUSRName'
    }])
    
    
     var MedicalTipsDR =  Ext.getCmp(ID +'theID').getValue();
     var rowid=Ext.getCmp(ID +'theID1').getValue();
   
     var grid = Ext.getCmp(ID + "GridPanel1");
     var MTStore = grid.getStore();
     
  /*   
     var Flag=0;  //�Ƿ��Ѿ�������ʾ
     MTStore.each(function(MTRecord){
            var MTipsDR = MTRecord.get('QMTCMedicalTipsDR');
            if (MTipsDR == MedicalTipsDR) {
                Flag = 1
				        ExtTool.alert('�ظ���ʾ','��ͬ����ʾ�Ѿ����ڣ����ʵ');
                return false;
            }
     });
     if (Flag == 1) return;
   */  
        
        	var p = new myRecord({
            checked: '',
            ID: rowid,
            QMTCMedicalTipsDR: MedicalTipsDR,
            QMTDesc: '',
            QMTDetail: '',
            QMTType: 'B',
            QMTRemark: '',
            QMTUpdateDate: '',
            QMTUpdateTime: '',
            QMTUpdateUsr: '',
            SSUSRName: ''
        });
        grid.stopEditing();
        MTStore.insert(0, p);
        
        grid.getView().refresh();
        MTStore.getAt(0).set("QMTDesc", Ext.getCmp(ID+'theMTDesc').getValue());
        MTStore.getAt(0).set("QMTDetail", Ext.getCmp(ID+'theMTDetail').getValue());
        
        	//------cxr----------------------------------------------
            //var grid = Ext.getCmp(ID + "GridPanel1");
            var store = grid.getStore();
            var modifyArray = store.modified.slice(0);
            //alert(grid+modifyArray);
            Ext.each(modifyArray, function(item, index, array){
				        var DataID = item.get("ID");
				     //   alert(DataID);
				        //alert(DataID);
                var MedicalTipsDR = item.get("QMTCMedicalTipsDR");
                if (MedicalTipsDR=="") return
                var desc = item.get("QMTDesc");
                var detail = item.get("QMTDetail");
                var type = item.get("QMTType");
                var remark = item.get("QMTRemark");
                if (resultStr == "") {
                    resultStr = DataID + Char2 + MedicalTipsDR + Char2 + desc + Char2 + detail + Char2 + type + Char2 + remark + Char2 + EID;
                }
                else {
                    resultStr = resultStr + Char1 + DataID + Char2 + MedicalTipsDR + Char2 + desc + Char2 + detail + Char2 + type + Char2 + remark + Char2 + EID;
                }
            });
           //alert(Type+'--'+resultStr);
        }
		//alert(Type+'--'+resultStr);
		
        if (resultStr == "") {
            ExtTool.alert("��ʾ", "û����Ҫ���������");
            store.load({
                    params: {
                        start: 0,
                        limit: 25
                    }
                });
            return;
        }
		    var User = session['LOGON.USERID'];
        var retStr = obj.Method.UpdateResult(Type, resultStr, User);
        Ext.MessageBox.hide();
		
        if (retStr == "") {
            if (Type == "T") {
                store.commitChanges();
                store.load({
                    params: {
                        start: 0,
                        limit: 25
                    }
                });
                obj.Clear_click();//cxr��� FORM 
            }
            ExtTool.alert("��ϲ", "���Ĳ����ɹ�");
        }
        else {
            ExtTool.alert("���ź�", "���Ĳ���û�гɹ���aaaa" + retStr);
            store.load({
                    params: {
                        start: 0,
                        limit: 25
                    }
                });
     
        }
    }
    obj.Submit_click = function(){
        var formPanel = obj.FormPanel3.getActiveTab();
        if (!formPanel) 
            return;
        var baseForm = formPanel.getForm();
        var panelID = formPanel.id;
        var Type = panelID.substring(1, 2);
        var ID = panelID.substring(2, panelID.length);
        var rStr = obj.Method.GetQuestionStatus(ID, Type, "S");
        if (rStr != "") {
            ExtTool.alert("��ʾ","����ʧ�ܣ� "+ rStr);
            return;
        }
        var User = session['LOGON.USERID'];
        var retStr = obj.Method.SubmitQuestion(Type, ID, User);
        if (retStr == "") {
            ExtTool.alert("��ϲ", "���Ĳ����ɹ�");
        }
        else {
            ExtTool.alert("���ź�", "���Ĳ���û�гɹ���" + retStr);
        }
    }
	obj.CancelSubmit_click = function(){
        var formPanel = obj.FormPanel3.getActiveTab();
        if (!formPanel) 
            return;
        var baseForm = formPanel.getForm();
        var panelID = formPanel.id;
        var Type = panelID.substring(1, 2);
        var ID = panelID.substring(2, panelID.length);
        var retStr = obj.Method.CanelSubmit(Type, ID);
        if (retStr == "") {
            ExtTool.alert("��ϲ", "���Ĳ����ɹ�");
        }
        else {
            ExtTool.alert("���ź�", "���Ĳ���û�гɹ���" + retStr);
        }
    }
    obj.Clear_click = function(){
        var formPanel = obj.FormPanel3.getActiveTab();
        if (!formPanel) 
            return;
        var baseForm = formPanel.getForm();
        var Value = baseForm.reset();
    }
    obj.PrintReport_click = function(){
    	var formPanel = obj.FormPanel3.getActiveTab();
        if (!formPanel) 
            return;
        var panelID = formPanel.id;
        var ID = panelID.substring(2, panelID.length);
        var width=screen.width-20;
	var height=screen.height-60;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no,width='+width+',height='+height+',left=10,top=5';
	var lnk="dhchmprintreport.csp?qID="+ID;
	open(lnk,"_blank",nwin);
    }
    obj.TreePanel_click = function(node, e){
    	//-----cxr----------------------
    	//Ext.getBody().mask('loading', 'x-mask-loading');
    	//Ext.MessageBox.wait('Loadng', 'Please Wait...');
      //Ext.MessageBox.updateProgress(1);
      //-----cxr----------------------
        var ID = node.id;
        if (ID == 0) 
            return;
        var Desc = node.text;
        var cmp = Ext.getCmp("P" + ID);
       
        if (cmp) {
	    if (!cmp.isVisible()) cmp.setVisible(true);
            obj.FormPanel3.setActiveTab("P" + ID);
            return;
        }
        CreateActivePanel(obj, ID, Desc);
        //CreateActivePanel(obj, "Q11||20", "�����������ʾ�Ů��(����)");
      //-----cxr----------------------
      //Ext.getBody().unmask();
     //Ext.MessageBox.hide();  
      //-----cxr---------------------- 
    };
    /*Viewport1��������ռλ��*/





























































































































































































































































}

