//Create by LiYang 2009-07-20 
//Modify Front Page Disease Info
//objRec:Record object in the disease grid
function DisplayDisRec(objRec) {
    var objICD = objRec.get("RelatedICDDic");
    var objDiaType = objRec.get("RelatedDiagnoseType");
    var objDisResult = objRec.get("RelatedDisResultDic");
    var objResume = objRec.get("RelatedResume");
    if (objDiaType == null) objDiaType = new DHCWMRDictionary();
    if (objDisResult == null) objDisResult = new DHCWMRDictionary();
    if (objResume == null) objResume = new DHCWMRDictionary();
    var rec = new Ext.data.Record(
      {
          id: objICD.RowID,
          code: objICD.Code,
          desc: objICD.Name,
          resume: "",
          SrcType:objRec.get("SrcType")
      });
     cboDiseaseICD.initialConfig.store.removeAll();    
     cboDiseaseICD.initialConfig.store.add([rec]);
     cboDiseaseICD.setValue(objICD.RowID);
     cboDiseaseResult.setValue(objDisResult.RowID);
     cboDiseaseType.setValue(objDiaType.RowID);
     txtDiseaseResume.setValue(objResume.RowID)     
    /*cboDiseaseICD.initialConfig.store.load({
        params: { ID: objICD.RowID },
        callback: function(recArry, option, success) {
        cboDiseaseICD.setValue(objICD.RowID);
        cboDiseaseResult.setValue(objDisResult.RowID);
        cboDiseaseType.setValue(objDiaType.RowID);
        txtDiseaseResume.setValue(objResume.RowID)        
        
        },
        add: true
    });*/
}

function DisplayOpeRec(objRec) {
    var objICD = objRec.get("RelatedICDDic");
    var objOperator = objRec.get("RelatedOperator");
    var objAss1 = objRec.get("RelatedAssistant1");
    var objAss2 = objRec.get("RelatedAssistant2");
    var objNarcosisType = objRec.get("RelatedNarcosisType");
    var objNarcDoctor = objRec.get("RelatedNarcosisDoctor");
    var objCloseUp = objRec.get("RelatedCloseUp");
    var objOpeType = objRec.get("RelatedOpeType");
    var objOperationRank=objRec.get("OperationRank");
    
    
    if (objNarcosisType == null) objDicNarcosisType = new DHCWMRDictionary();
    if (objCloseUp == null) objCloseUp = new DHCWMRDictionary();
    if (objOperator == null) objOperator = new DHCWMRUser();
    if (objAss1 == null) objAss1 = new DHCWMRUser();
    if (objAss2 == null) objAss2 = new DHCWMRUser();
    if (objNarcDoctor == null) objNarcDoctor = new DHCWMRUser();
    if (objOpeType == null) objOpeType = new DHCWMRDictionary();
		if(objOperationRank==null) objOperationRank=new DHCWMRDictionary();
	var rec = new Ext.data.Record(
	{
		id: objAss1.RowID,
		code: objAss1.Code,
		desc: objRec.get("Assistant1"),
		resume: "",
		SrcType:objRec.get("SrcType")
	});

    /*cboOperationICD.initialConfig.store.load({
        params: { ID: objICD.RowID },
        callback: function(recArry, option, success) {
            cboOperationICD.setValue(objICD.RowID);
        },
        add: true
    });*/
    
    var recOpe = new Ext.data.Record(
      {
          id: objICD.RowID,
          code: objICD.Code,
          desc: objICD.Name,
          resume: "",
          SrcType:objRec.get("SrcType")
      });
    cboOperationICD.initialConfig.store.removeAll();    
    cboOperationICD.initialConfig.store.add([recOpe]);   
    cboOperationICD.setValue(objICD.RowID);
    
    var rec = new Ext.data.Record(
        {
            id:objOperator.RowID,
            code: objOperator.Code,
            desc: objRec.get("Operator"),
            resume:""
        });
    cboOperator.initialConfig.store.removeAll();    
    cboOperator.initialConfig.store.add([rec]);
    SelectFirstComboBoxItem(cboOperator);

    rec = new Ext.data.Record(
        {
            id: objAss1.RowID,
            code: objAss1.Code,
            desc: objRec.get("Assistant1"),
            resume: ""
        });
    cboAssistant1.initialConfig.store.removeAll();
    cboAssistant1.initialConfig.store.add([rec]);
    SelectFirstComboBoxItem(cboAssistant1);

    rec = new Ext.data.Record(
        {
            id: objAss2.RowID,
            code: objAss2.Code,
            desc: objRec.get("Assistant2"),
            resume: ""
        });
    cboAssistant2.initialConfig.store.removeAll();
    cboAssistant2.initialConfig.store.add([rec]);
    SelectFirstComboBoxItem(cboAssistant2);

    rec = new Ext.data.Record(
        {
            id: objNarcosisType.RowID,
            code: objNarcosisType.Code,
            desc: objNarcosisType.Description,
            resume: ""
        });
    cboNarcosisType.initialConfig.store.removeAll();
    cboNarcosisType.initialConfig.store.add([rec]);
    SelectFirstComboBoxItem(cboNarcosisType);

    rec = new Ext.data.Record(
        {
            id: objNarcDoctor.RowID,
            code: objNarcDoctor.Code,
            desc: objRec.get("NarcosisDoctor"),
            resume: ""
        });
    cboNarcosisDoctor.initialConfig.store.removeAll();
    cboNarcosisDoctor.initialConfig.store.add([rec]);
    SelectFirstComboBoxItem(cboNarcosisDoctor);
    
    rec = new Ext.data.Record(
        {
            id: objCloseUp.RowID,
            code: objCloseUp.Code,
            desc: objCloseUp.Description,
            resume: ""
        });
    cboCloseUpType.initialConfig.store.removeAll();
    cboCloseUpType.initialConfig.store.add([rec]);
    SelectFirstComboBoxItem(cboCloseUpType);
   
    rec = new Ext.data.Record(
        {
            id: objOperationRank.RowID,
            code: objOperationRank.Code,
            desc: objRec.get("OperationRank"),
            resume: ""
        });
    cboOperationRank.initialConfig.store.removeAll();
    cboOperationRank.initialConfig.store.add([rec]);
    SelectFirstComboBoxItem(cboOperationRank);

//    rec = new Ext.data.Record(
//        {
//            id: objOpeType.RowID,
//            code: objOpeType.Code,
//            desc: objOpeType.Description,
//            resume: ""
//        });
//    cboOpeType.initialConfig.store.removeAll();
//    cboOpeType.initialConfig.store.add([rec]);
//    SelectFirstComboBoxItem(cboOpeType);
    cboOpeType.setValue(objOpeType.RowID);
    txtOperationDate.setValue(objRec.get("OperationDate"));
}

function CreateDicRecord() {
    return new Ext.data.Record(
        {
            id:"",
            code:"",
            desc:"",
            resume:""
        }
    );
}