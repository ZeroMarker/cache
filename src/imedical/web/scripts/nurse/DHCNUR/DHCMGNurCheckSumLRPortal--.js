var oArcSize=1
/*
function mStart()
{
	var oImg = document.all('oImg');
	oImg.style.filter = 'Progid:DXImageTransform.Microsoft.BasicImage(Rotation='+ oArcSize +')';
	oArcSize += 1;
	oArcSize = oArcSize==4 ? 0 : oArcSize ;
}*/
var imagenum=0
var sum=0
function BodyLoadHandler()
{
	/*
	var b=new Ext.BoxComponent({			
		xtype:'box',
		pressed:true,
		x:460,y:50,
		height:'220px',
		width:'260px',
		handler:function(){Ext.MessageBox.alert("nnnn");},
		autoEl:{
			tag:'img',
			src:''
		}
	});		
	var box1=new Ext.BoxComponent({
		xtype:'box',
		id:'imgBox',
		x:560,y:40, 
		autoShow:true,
		style:'margin-top:4px',
		// disabled:true,
		width:'260px', //图片宽度   
		height:'220px', //图片高度
		fileUpload:true,		    
		autoEl:{
			tag:'img',    //指定为img标签  
			id:'imgsrc', 
			src:'../../web/images/222349.png'   //指定url路径	            
			},
			listeners:{
				'beforerender': function () { 
        //alert('ooooo'); 
        } 
      },
			renderTo:Ext.getBody()
	});	
	*/
	var StatType = new Ext.form.ComboBox({
		name:'StatType',
		id:'statType',
		tabIndex:'0',
		height:20,
		width:80,
		x:660,y:510,
		renderTo:Ext.getBody(),
		xtype:'combo',
		store:new Ext.data.JsonStore({
			data:[{
				desc : '待处理',
			id : '1'
		}, {
			desc : '处理中',
			id : '2'
		}, {
			desc : '已解决',
			id : '3'
		},{
			desc : '问题上诉',
			id : '4'
			}],
			fields:['desc','id']
		}),
		displayField:'desc',
		valueField:'id',
		allowBlank:true,
		mode:'local',
		value:'',
		renderTo:Ext.getBody()
	});
	//alert(StatType.store.data[0]);
	var gform=Ext.getCmp('gform');  
	gform.add(StatType);
	gform.doLayout();
	sum=0
	imagenum=0
	//权限控制-------
	if((session['LOGON.GROUPDESC']!="护理部")&&(session['LOGON.GROUPDESC']!="护理部主任")&&(session['LOGON.GROUPDESC']!="Demo Group"))
	{
		Ext.getCmp("Praise").disable()
	}
	Ext.getCmp("upimg").setVisible(false)   //隐藏上一张
	Ext.getCmp("downimg").setVisible(false)   //隐藏下一张
	Ext.getCmp("Question").disable()      //存在问题不编辑
	var but1=Ext.getCmp("butSave");
	but1.on('click',function(){Save(Par,CheckTyp)});
	var but2=Ext.getCmp("Read");
	but2.on('click',function(){Readed(Par,CheckTyp)});
	/*/***********************
	pad夜查房保存图片 以后放开
	**************************/
	/*
	var SButton=Ext.getCmp("SButton");
	SButton.on('click',function(){
		var windowImage = new Ext.Window({
			title:'图片操作',
			id:"gform5",
			x:10,y:2,
			width:1000,
			height:650,    
			autoScroll:true,
			layout:'absolute',
			// plain: true,
			// modal: true,
			// bodyStyle: 'padding:5px;',
			// /buttonAlign: 'center',
			items:[{
				html:'<html><div align="center"><img id="oImg" src='+Ext.getCmp("imgBox").getEl().dom.src+' onDblClick="mStart();"></div></html>'
         //autoLoad: {url:Ext.getCmp("imgBox").getEl().dom.src}  ///style="position:relative; zoom:100%; cursor:move;"
      }]
		});
		windowImage.show();
	});
	*/
	//var getPatNurInfo = document.getElementById("getPatNurInfo");
	var Par=CheckId;
	var PatEpsiId=cspRunServerMethod(getPatNurInfo,CheckId,CheckTyp);
	//alert(PatEpsiId+"*");
	//if (Qreason!=""){
	//Ext.getCmp("Question").setValue(Qreason+PatEpsiId);
	//}
	//var getVal=document.getElementById('getVal');
	//alert("getVal="+getVal+"^"+Par+"^"+CheckTyp);
	var ret=cspRunServerMethod(getVal,Par,CheckTyp);
	var ret2=cspRunServerMethod(getQuesDescPortal,Par,CheckTyp);
	//alert(ret2)
	ret=ret.replace(/_n/g,"\n\r");
	ret2=ret2.replace(/_n/g,"\n\r");
  var arr=ret.split('^');
  var arr2=ret2.split('^');
  if(ret!=""){
  	//alert(arr);
  	//alert(Ext.getCmp('statType').getValue());
   	Ext.getCmp("Reason").setValue(arr[0]);
   	//Ext.getCmp("Reason").setValue("99999999");
   	Ext.getCmp("Method").setValue(arr[1]);
   	Ext.getCmp("Goal").setValue(arr[2]);
  	Ext.getCmp("Praise").setValue(arr[3]);
  	//alert(arr[4])
  	//Ext.getCmp("Opinion").setValue(arr[4]);
  	//alert(Ext.getCmp("Opinion").value)
  	Ext.getCmp("HRead").setValue(arr[5]);
  	Ext.getCmp("ReasonNurse").setValue(arr[6]);//
  	Ext.getCmp("ReasonPat").setValue(arr[7]);
  	Ext.getCmp("ReasonEnv").setValue(arr[8]);
  	Ext.getCmp("ReasonEpu").setValue(arr[9]);
  	Ext.getCmp("ReasonThings").setValue(arr[10]);
  	//Ext.getCmp('statType').setValue("3");
  	//Ext.getCmp("imgBox").getEl().dom.src="http://192.192.10.122/uploadimg/Images/117/117_2013925113244.jpg";
  }    
  if (ret2!=""){
  	Ext.getCmp('Question').setValue(arr2[0]);
  	//alert(arr2[1]);
  	Ext.getCmp('statType').setValue(arr2[1]);
  	}
  //获取图片地址
  /*
  if((CheckTyp=="NIGHTCHK")||(CheckTyp=="DAYCHK")){
	  var butup = Ext.getCmp("upimg");
		butup.on('click',function(){ upimage()});
		var butdown = Ext.getCmp("downimg");
		butdown.on('click',function(){ downimage()});
  	var getImages = document.getElementById('getImages');
   	var ret=cspRunServerMethod(getImages.value,Par,CheckTyp);
   	var arr=ret.split(';');
   	//alert(arr)
   	if(arr=="")
   	{
   		Ext.getCmp("imgBox").getEl().dom.src="../images/anhuiprovincial.jpg";	     		
   		butup.hide();
   		butdown.hide();  
 		}else
		{
			if(arr.length==1)
			{
				//pad图片上传地址 以后放开
   			//Ext.getCmp("imgBox").getEl().dom.src="http://192.192.10.122/uploadimg/Images/"+arr[0].split('_')[0]+"/"+arr[0]+".jpg";
   	 		butup.hide();
   			butdown.hide();
			}
   		if(arr.length>1){
   			sum=arr.length-1
   			butup.disable();
   			//pad图片上传地址 以后放开
	   	  //Ext.getCmp("imgBox").getEl().dom.src="http://192.192.10.122/uploadimg/Images/"+arr[0].split('_')[0]+"/"+arr[0]+".jpg";
  	 		//alert(Ext.getCmp("imgBox").getEl().dom.src)	     		
   		}
			}
	}
	
	if((CheckTyp=="QualCheck")||(CheckTyp=="QUALCHECK")||(CheckTyp.indexOf("QUAL")!=-1)){
 	  var butup = Ext.getCmp("upimg");
		butup.on('click',function(){ upimage1()});
		var butdown = Ext.getCmp("downimg");
		butdown.on('click',function(){ downimage1()});
		var getImages = document.getElementById('getImages');
   	//alert(8);
   	var ret=cspRunServerMethod(getImages.value,Par,CheckTyp);
    var arr=ret.split(';');
    if(arr==""){
   		Ext.getCmp("imgBox").getEl().dom.src="../images/anhuiprovincial.jpg";	     		
   		butup.hide();
   		butdown.hide();
  	}else{
  		if(arr.length==1){
  			//pad图片上传地址 以后放开
  			//Ext.getCmp("imgBox").getEl().dom.src="http://192.192.10.122/uploadimg/Images/"+arr[0].split('^')[0]+"/"+arr[0].split('^')[1].split('_')[0]+"/"+arr[0]+".jpg";
   	  	butup.hide();
   			butdown.hide();
			}
			if(arr.length>1){
				sum=arr.length-1
   			butup.disable();
   			//pad图片上传地址 以后放开
   	   	//Ext.getCmp("imgBox").getEl().dom.src="http://192.192.10.122/uploadimg/Images/"+arr[0].split('^')[0]+"/"+arr[0].split('^')[1].split('_')[0]+"/"+arr[0]+".jpg";
   			//alert(Ext.getCmp("imgBox").getEl().dom.src)	     		
   		}
		}
 	}

	function upimage()
	{
	 	if(imagenum>0) 
		{
			imagenum--;	
			butdown.enable();
		}
		Ext.getCmp("imgBox").getEl().dom.src="http://192.192.10.122/uploadimg/Images/"+arr[imagenum].split('_')[0]+"/"+arr[imagenum]+".jpg";
		if(imagenum==0) 
		{
			butup.disable();
		}
	}
	function downimage()
	{
		//alert(imagenum+"!"+sum)
		if(imagenum<sum){
			imagenum++;
			butup.enable();
		}
		Ext.getCmp("imgBox").getEl().dom.src="http://192.192.10.122/uploadimg/Images/"+arr[imagenum].split('_')[0]+"/"+arr[imagenum]+".jpg";
		if(imagenum==sum){
			butdown.disable();
		}
	}
	*/
	//病房质控
	/*
	function upimage1()
	{
		if(imagenum>0){
			imagenum--;
			butdown.enable();
		}
		Ext.getCmp("imgBox").getEl().dom.src="http://192.192.10.122/uploadimg/Images/"+arr[imagenum].split('^')[0]+"/"+arr[imagenum].split('^')[1].split('_')[0]+"/"+arr[imagenum]+".jpg";
		if(imagenum==0){
			butup.disable();
		}
	}
	function downimage1()
	{
		if(imagenum<sum){
			imagenum++;
			butup.enable();
		}
		Ext.getCmp("imgBox").getEl().dom.src="http://192.192.10.122/uploadimg/Images/"+arr[imagenum].split('^')[0]+"/"+arr[imagenum].split('^')[1].split('_')[0]+"/"+arr[imagenum]+".jpg";
		//Ext.getCmp("imgBox").getEl().dom.src="http://192.192.10.122/uploadimg/Images/"+arr[imagenum].split('_')[0]+"/"+arr[imagenum]+".jpg";
		if(imagenum==sum){
			butdown.disable();
		}
	}
	*/
}
function Save(checkid,CheckTyp,stateType)
{
	//alert("testSave");
	Reasona=Ext.getCmp("Reason").getValue()
	Methoda=Ext.getCmp("Method").getValue()
	Goala=Ext.getCmp("Goal").getValue()
	Praisea=Ext.getCmp("Praise").getValue()
	//Opiniona=Ext.getCmp("Opinion").getValue()
	//Reasona=Ext.getCmp("Reason").getValue()
	ReasonNursea=Ext.getCmp("ReasonNurse").getValue()
	ReasonPata=Ext.getCmp("ReasonPat").getValue()
	ReasonEnva=Ext.getCmp("ReasonEnv").getValue()
	ReasonEpua=Ext.getCmp("ReasonEpu").getValue()
	ReasonThingsa=Ext.getCmp("ReasonThings").getValue()
	//alert("t2");
	//var parr=Reasona+"^"+Methoda+"^"+Goala+"^"+Praisea+"^"+Opiniona+"^"+ReasonNursea+"^"+ReasonPata+"^"+ReasonEnva+"^"+ReasonEpua+"^"+ReasonThingsa
	var parr=Reasona+"^"+Methoda+"^"+Goala+"^"+Praisea+"^"+""+"^"+ReasonNursea+"^"+ReasonPata+"^"+ReasonEnva+"^"+ReasonEpua+"^"+ReasonThingsa
	//var SaveCheck=document.getElementById('SaveCheckSum');
	var stateType=Ext.getCmp('statType').getValue();
	//alert(parr+"^"+checkid+"^"+CheckTyp+"^"+stateType);
	var a=cspRunServerMethod(SaveCheck,parr,checkid,CheckTyp,stateType);
	alert("保存成功");
	//self.location.reload();
	
}
function Readed(checkid,CheckTyp)
{
	//alert("Read");
	var username=session['LOGON.USERNAME']
	//var ReadSave=document.getElementById('ReadSave');
	var a=cspRunServerMethod(ReadSave,username,checkid,CheckTyp);
	//alert(a)
	if(a!=""){
		alert("阅读成功");
		self.location.reload();
	}
}
