//document.write('<link rel="stylesheet" type="text/css" href="./resources/css/ext-all.css" />');





var objCurrTemplate = null; //Front Page Template
var arryItemDic = new Array();//Store the details of template
var dicItemDic =  new ActiveXObject("Scripting.Dictionary");

var arryExtraControl = new Array();
var frmExtra = null;
var panelExtraControl = null;
var dicSavedExtra = new ActiveXObject("Scripting.Dictionary");

function  InitExtra()
{

    //LoadTemplate();
    var obj = null;
    
         Ext.QuickTips.init();   

    /*for(var i = 0; i <6; i ++)
    {
        obj = new Ext.form.TextField({fieldLabel:"txt"+i,width:200});
        obj.on('specialkey', ExtraControl_Onkeydown, obj);
        arryExtraControl[i]=obj;
    }*/

        panelExtraControl = new Ext.Panel(
            {
                 layout:'form'
            }
        )
        
        Ext.form.Field.prototype.msgTarget = 'side';
        var objSetting = {
            labelAlign: 'left',
            layout:'fit',
            frame:true,
            //title: strSummaryGridTitle,
            bodyStyle:'padding:5px 5px 0',
            width: 1000,
            renderTo:"SummaryGrid",
           // title:strSummaryGridTitle,
            items: [
                    panelExtraControl
                ]
        };
        //var bd = Ext.getBody();
        //a();
        frmExtra = new Ext.FormPanel(objSetting);
    
    //initControl();
}

function ExtraControl_Onkeydown(objSrc, objEvent)
{
    var intKeyCode = objEvent.getKey();
    var obj = null;
    for(var i = 0; i < arryExtraControl.length; i ++)
    {
        obj = arryExtraControl[i];
        if(obj.getId() != objSrc.getId())
            continue;

        switch(intKeyCode)
        {
            case objEvent.ENTER:
            case objEvent.RETURN:
            case objEvent.DOWN:
                if(i < arryExtraControl.length-1)
                {
                    arryExtraControl[i+1].focus();
                }
                else
               {
                    objTabs.activate(objDisTab);
                    cboDiseaseICD.focus();
               } 
                break;
            case objEvent.UP:
                if(i > 0)
                {
                    arryExtraControl[i-1].focus();
                }
                break;
            default:
                //window.alert(objEvent.keyCode);
                break; 
                      
        }
    }
}
                
 function LoadTemplate()
 {
 		var objVolume = GetDHCWMRMainVolumeByID("MethodGetDHCWMRMainVolumeByID", strVolRowID);
 		var objMain = GetDHCWMRMainByID("MethodGetDHCWMRMainByID", objVolume.Main_Dr);
    var strMrType = objMain.MrType;
    var objDetail = null;
    var objControl = null;
    var objPanel = null;
    arryExtraControl = new Array();
		if(strMrType == "")
		{
			//a();
			window.alert("Medical record type not set!!!!!!!");
			window.close();
			return;
		}
    //objCurrTemplate = GetDHCWMRFPTemplateByID("MethodGetDHCWMRFPTemplateByID", strTemplateID);
    var arryCurrTemplateDtl = GetTemplateDetailByMrType("MethodGetTemplateDetailByMrType", strMrType);
    arryCurrTemplateDtl.sort(function(a,b){if (a.Pos+0>b.Pos+0){return 1}else{return -1;};});  //wangcs 2012-12-04 增加排序功能
    dicItemDic.RemoveAll(); 
    for(var i = 0; i < arryCurrTemplateDtl.length; i ++)
    {
         objDetail = arryCurrTemplateDtl[i];
         if(objDetail == null)
         continue;
         //**********************************************************************************
         //Update 2010-05-31
				 //objDetail.RelatedDtl = GetFrontPageItemDicByID("MethodGetFrontPageItemDicByID", objDetail.ItemId);
				 objDetail.RelatedDtl = GetFrontPageItemDicByIDNew("MethodGetFrontPageItemDicByIDNew", objDetail.ItemId, objVolume.Paadm_Dr);
				 //**********************************************************************************
         //objDetail.RelatedDtl.DataTypeDic = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", objDetail.RelatedDtl.DataType);
				 objControl = CreateExtraControl(objDetail.RelatedDtl);
				 arryExtraControl[arryExtraControl.length] = objControl;
         objDetail.RelatedControl = objControl;
         dicItemDic.Add(objControl.getId(), objDetail.RelatedDtl);
         arryItemDic.push(objDetail.RelatedDtl);
         
         switch(objDetail.RelatedDtl.DefaultValue)
         {
         		case "#AdmitDate#":
         			objControl.setValue(objCurrAdm.AdmitDate);
         			break;
         		default:
         			objControl.setValue(objDetail.RelatedDtl.DefaultValue);
         			break;
         }
    }
    if (arryExtraControl.length>0)      //add by wuqk 2008-05-13 
    {
        panelExtraControl = new Ext.Panel(
            {
                 layout:'form',
                 items:arryExtraControl
            }
        )
       frmExtra.items.addAll([panelExtraControl]);  
   }


   frmExtra.doLayout();
   //frmExtra.expand();
 }
 
 	//ps:objDetail:front page template detail information
  function CreateExtraControl(objDic)
  {
  			var objDataTypeDic = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", objDic.DataType);
  	    var strTooltip = ""; 
         if(objDataTypeDic.Code == "01")
         {
            objControl = new Ext.form.TextField({
                fieldLabel : objDic.Description + strTooltip,
                width:400,
                value:objDic.DefaultValue
                 });
         }
         if(objDataTypeDic.Code == "02")
         {
            objControl = new Ext.form.NumberField({
                fieldLabel : objDic.Description  + strTooltip,
                width:400,
                value:objDic.DefaultValue
                 });
         }
         if(objDataTypeDic.Code == "03")
         {
            objControl = new Ext.form.DateField({
                fieldLabel : objDic.Description  + strTooltip,
                width:400,
                value:objDic.DefaultValue,
                format:'Y-m-d'
                 });         
         }
         if(objDataTypeDic.Code == "04")
         {
            objControl = CreateDicQueryComboBox(objDic.DictionaryName, objDic.Description  + strTooltip);
         }            
         if((objDataTypeDic.Code == "D") || (objDataTypeDic.Code == "O"))
         {
            objControl = CreateICDDicQueryComboBox(objDic.Code, objDic.Description  + strTooltip);
         }
         objControl.on('specialkey', ExtraControl_Onkeydown, objControl);
         return objControl;
  } 

  function GetExtraList()
  {
        var objArry = new Array();
        var objDic = null;
        var objItm = null;
        for(var i = 0; i < arryExtraControl.length; i ++)
        {
            objDic = dicItemDic.Item(arryExtraControl[i].getId());
            if(dicSavedExtra.Exists(arryExtraControl[i].getId()))
            {
            	objItm = dicSavedExtra.Item(arryExtraControl[i].getId());
            }
            else
            {
            	objItm = DHCWMRFPExtra();
            	objItm.ItemId = objDic.RowID;
            }
            objItm.ItemValue = arryExtraControl[i].getRawValue();    //update by liyang 
//             if(arryExtraControl[i].format == "Y-m-d")
//             {
//             	objItm.ItemValue = arryExtraControl[i].getRawValue();
//             }
//           	else
//           	{
//           		objItm.ItemValue = arryExtraControl[i].getValue();
//           	}
            objItm.Pos = i + 1;
            objArry.push(objItm);
        }
        return objArry;
  } 

function ClearExtraControlList()
{
	var objArry = new Array();
	  for(var i = 0; i < frmExtra.items.getCount(); i ++)
    {
    	objArry.push(frmExtra.items.item(i));
    }
	frmExtra.items.clear();

	   frmExtra.doLayout();
	for(var i = 0; i < objArry.length; i ++)
	{
		objArry[i].hide();
		objArry[i].destroy();	
	}
	frmExtra.doLayout();
	arryItemDic = new Array();
  dicItemDic.RemoveAll();
}

function DisplayExtraInfo(arry)
{
	var objExtra = null;
	var objDic = null;
	var objControl = null;    
	var objPanel = null;
	if(arry.length == 0)
		return ;
  arryExtraControl = new Array();
  
  for(var i = 0; i < arry.length; i ++)
  {
  	objExtra = arry[i];
  	objDic = GetFrontPageItemDicByID("MethodGetFrontPageItemDicByID", objExtra.ItemId);
    //objExtra.RelatedDtl = //GetFrontPageItemDicByID("MethodGetFrontPageItemDicByID", objExtra.ItemId);
    objControl = CreateExtraControl(objDic);
    //if(objControl.ObjDic.DictionaryName == "")//Text Fields
    //{
    	objControl.setValue(objExtra.ItemValue);
    //}
  	//else
  	//{
  	//	objControl.setValue(objExtra
  	//}
		arryExtraControl[arryExtraControl.length] = objControl;
    dicItemDic.Add(objControl.getId(), objDic);
    dicSavedExtra.Add(objControl.getId(), objExtra);
  }
  //window.alert(dicItemDic.Count);
  panelExtraControl = new Ext.Panel(
	  {
	    layout:'form',
	    items:arryExtraControl
	  }
  )
  frmExtra.items.addAll([panelExtraControl]);  
  frmExtra.doLayout();
}
 