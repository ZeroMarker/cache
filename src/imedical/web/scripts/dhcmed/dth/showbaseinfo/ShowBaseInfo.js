
function InitViewPort(){
	var obj=new Object();

	obj.TxtRegNo=new Ext.form.Label({
        id:'TxtRegNo'
        ,fieldLabel:"<span style='font-size:18px;'><b>病案号</b></span>"
        ,width:130
        ,disabled:true
        ,style:'font-size:30px;'
       // ,cls : 'aa'
    });
    obj.TxtRegNo.text="111";
    obj.TxtMrNo=new Ext.form.TextField({
        id:'TxtMrNo'
        ,fieldLabel:'病案号'
        ,width:120
        ,disabled:true
    });
     obj.TxtPatName=new Ext.form.TextField({
        id:'TxtPatNameId'
        ,fieldLabel:'病人姓名'
        ,width:140
        ,disabled:true
    });
    obj.TxtSex=new Ext.form.TextField({
        id:'TxtSexId'
        ,fieldLabel:'性别'
        ,width:100
        ,disabled:true
    });
    obj.TxtCountry=new Ext.form.TextField({
        id:'TxtCountryId'
        ,fieldLabel:'国家或地区'
        ,width:100
        ,disabled:true
    });
    
    obj.TxtNation=new Ext.form.TextField({
        id:'CboNation'
        ,fieldLabel:'民族'
        ,width:130
        ,disabled:this
    });
    obj.CboCardType=new Ext.form.TextField({
        id:'CboCardType'
        ,fieldLabel:'证件类型'
        ,width:140
        //,disabled:true
    });
    
    obj.TxtIdentify=new Ext.form.TextField({
        id:'TxtIdentifyId'
        ,fieldLabel:'身份证号'
        ,width:140
        //,disabled:true
    });
    obj.TxtBirthday=new Ext.form.TextField({
        id:'TxtBirthday'
        ,fieldLabel:'出生日期'
        ,width:100
        ,disabled:true
    });
    obj.TxtAge=new Ext.form.TextField({
        id:'TxtAgeId'
        ,fieldLabel:'年龄'
        ,width:135
        ,disabled:true
    })
    
    
    obj.CboMarital=new Ext.form.TextField({
        id:'CboMarital'
        ,fieldLabel:'婚姻状况'
        ,width:320
    });
    obj.CboEducation=new Ext.form.TextField({
        id:'CboEducation'
        ,fieldLabel:'文化程度'
        ,width:320
    });
    obj.CboOccupation=new Ext.form.TextField({
        id:'CboOccupation'
        ,fieldLabel:'职业'
        ,width:320
    });
    obj.CboWorkType=new Ext.form.TextField({
        id:'CboWorkType'
        ,fieldLabel:'工种'
        ,width:320
    });
    obj.TxtCompany=new Ext.form.TextField({
        id:'TxtCompanyId'
        ,fieldLabel:'工作单位'
        ,width:320
    });
    
     obj.TxtRegAddress=new Ext.form.TextField({
        id:'TxtRegAddress'
        ,fieldLabel:'户籍地址'
        ,width:260
        //,disabled:true
        
    });
    obj.TxtCurrAddress=new Ext.form.TextField({
        id:'TxtCurrAddress'
        ,fieldLabel:'生前住址'
        ,width:300
    });
    
    obj.TxtFamName=new Ext.form.TextField({
        id:'TxtFamNameId'
        ,fieldLabel:'家属姓名'
        ,width:130
    });
    obj.CboFamRelation=new Ext.form.TextField({
        id:'CboFamRelation'
        ,fieldLabel:'关系'
        ,width:140
    });
    
    obj.TxtFamTel=new Ext.form.TextField({
        id:'TxtFamTelId'
        ,fieldLabel:'联系电话'
        ,width:140
    });
     obj.TxtFamAddress=new Ext.form.TextField({
        id:'TxtFamAddressId'
        ,fieldLabel:'家属住址或工作单位'
        ,width:255
    });
    
    obj.FirstRowPanel=new Ext.Panel({
        id:'FirstRowPanelId'
		,title : ''
		,layout:'column'
		,labelAlign:'right'
		//,width:1000
		
        ,items:[
       	  	{
              items:obj.TxtRegNo
              ,layout:'form'
              ,columnWidth:.2
              ,labelWidth:80}
             ,{
              items:obj.TxtMrNo
              ,layout:'form'
              ,columnWidth:.2
              ,labelWidth:55}
            ,{
               items:obj.TxtPatName
              ,layout:'form'
              ,columnWidth:.2
              ,labelWidth:55}
            ,{
              items:obj.TxtSex
              ,layout:'form'
              ,columnWidth:.2
              ,labelWidth:55}
            ,{
              items:obj.TxtCountry
              ,layout:'form'
              ,columnWidth:.2
              ,labelWidth:55}
        ]
    });
    
    obj.SecondRowPanel=new Ext.Panel({
        id:'SecondRowPanel'
        ,title:''
        ,layout:'column'
        ,labelAlign:'right'
        ,width:1000
         
        ,items:[
            {
             items:obj.TxtNation
             ,layout:'form'
             ,columnWidth:.2
             ,labelWidth:55}
             ,{ 
              items:obj.CboCardType
              ,layout:'form'
              ,labelWidth:55
              ,columnWidth:.2}
            ,{ 
              items:obj.TxtIdentify
              ,layout:'form'
              ,labelWidth:55
              ,columnWidth:.2}
           ,{ 
              items:obj.TxtBirthday
              ,layout:'form'
              ,labelWidth:55
              ,columnWidth:.2}
            ,{ 
               items:obj.TxtAge
               ,layout:'form'
               ,labelWidth:70
               ,columnWidth:.2} 
               ]
    });
     obj.FourthRowPanel=new Ext.Panel({
        id:'FourthRowPanel'
        ,title:''
        ,width:1000
        ,layout:'column'
        ,labelAlign:'right'
        ,items:[
            {
             items:obj.CboMarital
             ,layout:'form'
             ,columnWidth:.2
             ,labelWidth:55}
            ,{
             items:obj.CboEducation
             ,layout:'form'
             ,columnWidth:.2
             ,labelWidth:55}
            ,{
             items:obj.CboOccupation
             ,layout:'form'
             ,columnWidth:.2
             ,labelWidth:55}
            ,{
             items:obj.TxtCompany
             ,layout:'form'
             ,columnWidth:.2
             ,labelWidth:55}
             ,{
             items:obj.TxtRegAddress
             ,layout:'form'
             ,columnWidth:.2
             ,labelWidth:55}
            ]
    });
    
    obj.SixthRowPanel=new Ext.Panel({
        id:'SixthRowPanelId'
        ,title:''
        ,layout:'column'
        ,width:1000
        ,labelAlign:'right'
        ,items:[
             {
             items:obj.TxtCurrAddress
             ,layout:'form'
             ,columnWidth:.19
             ,labelWidth:55}
            , {
             items:obj.TxtFamName
             ,layout:'form'
             ,columnWidth:.21
             ,labelWidth:55}
            , {
              items:obj.CboFamRelation
              ,layout:'form'
              ,columnWidth:.4
              ,labelWidth:120}
              , {
              items:obj.TxtFamTel
              ,layout:'form'
              ,columnWidth:.4
              ,labelWidth:120}
              , {
              items:obj.TxtFamAddress
              ,layout:'form'
              ,columnWidth:.4
              ,labelWidth:120}
        ]
    });
    
   // obj.TxtRegNo.setValue("aaaa");
    obj.BaseInfoPanel = new Ext.form.FormPanel({
        id:'BaseInfoPanelId'
        ,title:'基本信息'
        ,region:'center'
        //,height:195
        ,frame:true
        ,labelAlign:'right'
        ,labelWidth : 70
       
        ,items:[
            obj.FirstRowPanel
            ,obj.SecondRowPanel
            ,obj.FourthRowPanel
            ,obj.SixthRowPanel
        ]
        
    });
    
        obj.MainViewPort=new Ext.Viewport({
        id:'MainViewPortId'
        ,layout:'border'
        ,height:80
         
        ,items:[
            obj.BaseInfoPanel
        ]
    });
}
Ext.onReady(InitViewPort);