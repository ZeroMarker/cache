var selid="";flag="";

function InitViewport1Event(obj) {
	var TheOBJ = ExtTool.StaticServerObject("web.DHCHM.BaseDataSet");

	obj.btNewRecord_click = function()
	{	 
		//person.fireEvent('walk'); 
		
		//Ext.MessageBox.wait('Loadng...........', '���ڴ򿪣���ȴ�');
    //Ext.MessageBox.updateProgress(1);   
    //setTimeout('winopen();', 1);
    winopen();
    
    /*  
    var delay=new Ext.util.DelayedTask(winopen() ); 
    delay.delay(2000);
    */
	};
  winopen = function()
	{ 
		if (TheWindowsobj==null){InitWindow8();}	
	  selid="";
	  TheWindowsobj.Window8.show();
	  TheWindowsobj.btCancel_click();
	}
	obj.btModify_click = function()
	{
	//���ڴ������¼��������
	obj.FormPanel3.getForm().reset();
	TheMainobj.param1.focus(true,3);  
	
		TheMainobj.ItemListStore.load({
		params: {
                	start: 0,
                	limit: 20
            	}
            	   
	});
	//�����Ҫ��ȡ����������ʹ��var myArg = arguments[i]��ʽ 
	};
	obj.btFindRecord_click = function()
	{
	//���ڴ������¼��������
		TheMainobj.ItemListStore.load({
		params: {
                	start: 0,
                	limit: 20
            	}
	});
	//�����Ҫ��ȡ����������ʹ��var myArg = arguments[i]��ʽ 
	};
	obj.LoadEvent = function(args)
  {};
	obj.ItemList_cellclick = function()
	{
	//���ڴ������¼��������
	//�����Ҫ��ȡ����������ʹ��var myArg = arguments[i]��ʽ 
	};
	obj.ItemList_rowclick = function(g,row,e)
	{	
		
		//Ext.MessageBox.wait('Loadng...........', '���ڴ򿪣���ȴ�');
    //Ext.MessageBox.updateProgress(1);      
    //setTimeout('winopen();', 1)
    winopen();
	//���ڴ������¼��������
	//TheWindowsobj.FormPanel300.getForm().reset();//�������
		var record = g.getStore().getAt(row);
		//if  (record.get('MTActive')=='Y') record.set('MTActive',true);
		//if  (record.get('MTActive')=='N')  record.set('MTActive',false); 
	//	alert(record.get('MTActive'));
		TheWindowsobj.FormPanel300.getForm().loadRecord(record);
		 //selid = g.getSelectionModel().getSelected().id;
		 
		  selid =TheWindowsobj.ID.getValue();
		  
		  TheWindowsobj.BIName.focus(true,3); 
		 
	
	//�����Ҫ��ȡ����������ʹ��var myArg = arguments[i]��ʽ 
	};
/*Viewport1��������ռλ��*/


}
function InitWindow8Event(obj) {
	var TheOBJ = ExtTool.StaticServerObject("web.DHCHM.BaseDataSet");
	obj.LoadEvent = function(args)
  {
  	 //obj.BIName.focus(true,3); 
  	};
	obj.btSave_click = function()
	{
	//���ڴ������¼��������
	//if(obj.BICode.getValue()=="") {
	//		ExtTool.alert("��ʾ","���벻��Ϊ�գ�");
	//		return;
	//	}
	//if(obj.BIPAPMINo.getValue()=="") {
	//		ExtTool.alert("��ʾ","�ǼǺŲ���Ϊ�գ�");
	//		return;
	//	}
	if(obj.BIName.getValue()=="") {
			ExtTool.alert("��ʾ","��������Ϊ�գ�");
			return;
		}
	if(obj.BICSexDR.getValue()=="") {
			ExtTool.alert("��ʾ","�Ա���Ϊ�գ�");
			return;
		}
	if(obj.BICServiceClassDR.getValue()=="") {
			ExtTool.alert("��ʾ","���񼶱���Ϊ�գ�");
			return;
		}		
				
	//if (selid=='') obj.BICode.setValue(TheOBJ.GetUserCode());	
	//alert(obj.BICode.getValue())
	
	var property = 'BICode^BIPAPMINo^BICSexDR^BIDOB^BITel^BICOccupationDR^BICServiceClassDR^BIHMDR^BIName^BICCertificateTypeDR^BIInputCode^BICNationDR^BICity^BICEducationDR^BICUserGroupDR^BIDocDR^BIIDCard^BIPassWord^BIMobilePhone^BIPostCode^BICUserTypeDR^BIEmail^BICMaritalDR^BICompany^BIAddress^BIRemark';
	var tmp = ExtTool.GetValuesByIds(property);	
	//alert(tmp);
//alert(selid);
	try
		{  
			var ret = TheOBJ.OBaseInfoSave(selid,tmp,property);	
			
			//�з��ִ�
			
			var tmp8=ret.split("$")[1];
			ret=ret.split("$")[0]
		//	alert(ret+","+tmp8);
			
			if(ret.split("^")[0] == -1) {
				ExtTool.alert("ʧ��",ret.split("^")[1]);
				return;
			}
			else{
			TheWindowsobj.Window8.setVisible(false);
			//TheMainobj.ItemListStore.load({params: {start: 0,limit: 20}});
				//�˴����ø��� �� �½�֮��� GRID��ʾ ��������� λ����ǰ�ȣ�
			obj.ID.setValue(ret);
			if (tmp8!='') obj.BICode.setValue(tmp8);
			
			if (flag=="") 
                        { 
                           var therecord=ExtTool.FormToGrid(selid,TheMainobj.ItemList,TheWindowsobj.FormPanel300); 
                           
                          
                            

                           therecord.set('SexDesc',obj.BICSexDR.getRawValue());
                           
                        }
                        else
                           TheMainobj.ItemListStore.load({params: {start: 0,limit: 20}});
			flag="";
			obj.btCancel_click();
		
				//�����ظ�����	
			  var infoStr=ret.split("^");
	      if (infoStr[0]=="-1") {
	     	ExtTool.alert ("��ʾ", infoStr[1]);
	      }
			
		
			}
		}catch(err)
		{
			
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
			
		}
	
	//�����Ҫ��ȡ����������ʹ��var myArg = arguments[i]��ʽ 
	};
	obj.btCancel_click = function()
	{
	//���ڴ������¼��������
	//alert('sd');
	    obj.FormPanel300.getForm().reset();
	   selid=""; obj.ID.setValue(selid);
	   TheWindowsobj.BIName.focus(true,3); 
	//�����Ҫ��ȡ����������ʹ��var myArg = arguments[i]��ʽ 
	};
	obj.btFind_click = function()
	{
	//���ڴ������¼��������
	
	TheWindowsobj.Window8.setVisible(false);
	//�����Ҫ��ȡ����������ʹ��var myArg = arguments[i]��ʽ 
	};
  obj.BIName_change= function(a,b,c)
	{
	obj.BIInputCode.setValue(getPinyin(b));
	//alert(getPinyin("ƴ������"));
	};
	
obj.BIPAPMINo_change= function(a,b,c)
	{
if (b.getKey() == b.ENTER) {
	  //var TheOBJ = ExtTool.StaticServerObject("web.DHCHM.BaseDataSet");
	  //var ret = TheOBJ.OBaseInfoSave(selid,tmp,property);
	  //1.ǰ���0 
//	  if (selid!='') return;  //������½�
 
	  var TheOBJ1 = ExtTool.StaticServerObject("web.DHCHM.Tools");

	  
	  var theno=TheOBJ1.RegNoMask(obj.BIPAPMINo.getValue());
	//  obj.FormPanel300.getForm().reset();
	  obj.BIPAPMINo.setValue(theno);
	  
	 
   
	  //2.��ѯ�Ƿ��Ѿ�����
	  var tmp=TheOBJ.FindBIPAPMINo(theno);
	  if (tmp!='')
	  { ExtTool.alert("��ʾ","�˵ǼǺ��û��Ѿ����ڣ�");
	    //����������FORM
  
	    var baseJson = Ext.decode(tmp);
	
	    var rec = new Ext.data.Record(baseJson);
	
          obj.FormPanel300.getForm().loadRecord(rec);
          selid =TheWindowsobj.ID.getValue();
          flag="1";
	  //  alert(selid);
	    return;
	  }
        
	  //3.��������
	  
	  tmp=TheOBJ.GetJSONbyBIPAPMINo(theno);
	  //���DHC����Ҳû��
	 // alert(tmp);
	
	  if (tmp=="{'BIName':''}")
	  {
	    ExtTool.alert("��ʾ","�˵ǼǺŲ����ڣ�");
	    obj.FormPanel300.getForm().reset();
	    selid=""; obj.ID.setValue(selid);
	    return;
	  }
	  
	  selid =TheWindowsobj.ID.getValue();
	  var tmp0=TheWindowsobj.BICode.getValue();
	  obj.FormPanel300.getForm().reset();
	  TheWindowsobj.ID.setValue(selid);
	  TheWindowsobj.BICode.setValue(tmp0);
	  TheWindowsobj.BIPAPMINo.setValue(theno);
	  
	  
	  var baseJson = Ext.decode(tmp);
//alert(tmp );
	
	  var rec = new Ext.data.Record(baseJson);
	//  alert(rec.get('BIName'));
          obj.FormPanel300.getForm().loadRecord(rec);
          
          TheWindowsobj.BIName.focus(true,3); 
     };      
	  
	};
obj.BIIDCard_change= function(a,b,c)
	{
		//alert (b);
		isIdCardNo(b)
	}	
	
obj.Window8_show=function(a)
{
	//alert("");
	TheWindowsobj.BIName.focus(true,3); 
	//Ext.MessageBox.hide();

}
///�ж����֤��?�����������Ϊ���Զ���������
function isIdCardNo(num) {
	if (num=="") return true;
	var ShortNum=num.substr(0,num.length-1)
	if (isNaN(ShortNum))
	{
		//alert("����Ĳ�������?");
		return true;
	}
	//alert(num);
	var len = num.length;
	var re;
	if (len == 15) re = new RegExp(/^(\d{6})()?(\d{2})(\d{2})(\d{2})(\d{3})$/);
	else if (len == 18) re = new RegExp(/^(\d{6})()?(\d{4})(\d{2})(\d{2})(\d{3})(\d)$/);
	else {
		alert("���֤�����������λ������?");
	   TheWindowsobj.BIIDCard.focus(true,3); 
	return true;}
	var ShortNum=ShortNum+"1"
	var a = (ShortNum).match(re);
	if (a != null)
	{
		if (len==15)
		{
			var D = new Date("19"+a[3]+"/"+a[4]+"/"+a[5]);
			var B = D.getYear()==a[3]&&(D.getMonth()+1)==a[4]&&D.getDate()==a[5];
		}
		else
		{
			var D = new Date(a[3]+"/"+a[4]+"/"+a[5]);
			var B = D.getFullYear()==a[3]&&(D.getMonth()+1)==a[4]&&D.getDate()==a[5];
		}
		if (!B)
		{
			alert("��������֤�� "+ a[0] +" ��������ڲ���?");
			//websys_setfocus("IDCard"); //DGV2DGV2
			
			 TheWindowsobj.BIIDCard.focus(true,3); 
			 
			return false;
		}
		//var obj=document.getElementById("DOB");
		var obj=TheWindowsobj.BIDOB;
		
		//alert(a[5]+"/"+a[4]+"/"+a[3]);
		//if ((obj)&&(obj.value=="")) obj.value=a[5]+"/"+a[4]+"/"+a[3];
		//if (obj) obj.value=a[5]+"/"+a[4]+"/"+a[3];
		obj.setValue(a[5]+"/"+a[4]+"/"+a[3]);
		
//		var Dateinit=new Date           //add by zhouli start	�������֤�ź�tab�������Զ���������	
//        var Yearinit=Dateinit.getYear()
//	    var Year=Yearinit-a[3]
	    
	    /*
		var obj=document.getElementById("Age");
		if (obj) obj.value=Year;       //add by zhouli end 
	 */
	 	if (len==15)
		{
			var SexFlag=num.substr(14,1);
		}
		else
		{
			var SexFlag=num.substr(16,1);
		}
           
            		
		var SexNV="0^1^2^3^4"
		//var obj=document.getElementById("SexNV");
		var obj=TheWindowsobj.BICSexDR;
		
		//if (obj) SexNV=obj.value;
		//SexNV=SexNV.split("^");
		//var obj=document.getElementById("Sex_DR_Name");
		//alert(SexNV[2]+"-"+SexNV[3])
		if (SexFlag%2==1)
		{
			//obj.value=SexNV[2];
			obj.setValue(7);
		}
		else
		{
			//obj.value=SexNV[3];
			obj.setValue(5);
		}
	}
	return true;
}
/*Window8��������ռλ��*/
}

