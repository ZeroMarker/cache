
var unitsUrl = 'dhcpha.comment.main.save.csp';

//��ҩѧ���ര��
OpenDrugCatWinFun = function() {
	
   Ext.QuickTips.init();
   Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

   var OpenDrugCatButton = new Ext.Button({
             width : 55,
             id:"OpenDrugCatBtn",
             text: 'ȷ��',
             icon:"../scripts/dhcpha/img/edit.gif",
             listeners:{   
                          "click":function(){  
              
                           SelectOne();
                       
                           
                              }   
                       } 
             
             })		
	

	
	
   
	
	 ///������ʽ
	
	 var ComBoCatDs = new Ext.data.Store({
		autoLoad: true,
		proxy : new Ext.data.HttpProxy({
			url : unitsUrl
					+ '?action=GetPhcCatDs',
			method : 'POST'
		}),
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'drugcatrowid'},['drugcatdesc','drugcatrowid'])
				
	});
	

	var ComBoCat = new Ext.form.ComboBox({
		store: ComBoCatDs,
		displayField:'drugcatdesc',
		mode: 'local', 
		width : 120,
		id:'catcomb',
		emptyText:'',
		listWidth : 200,
		valueField : 'drugcatrowid',
		emptyText:'ѡ��ҩѧ����...',
		fieldLabel: 'ҩѧ����'
	}); 
	
	
	//ҩѧ����
	
	
    var ComBoSubCatDs = new Ext.data.Store({
		//autoLoad: true,
		//proxy : new Ext.data.HttpProxy({
		//	url : unitsUrl
		//			+ '?action=GetPhcSubCatDs',
		//	method : 'POST'
		//}),
    	proxy :'',
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'drugsubcatrowid'},['drugsubcatdesc','drugsubcatrowid'])
				
	});
	
	

	var ComBoSubCat = new Ext.form.ComboBox({
		store: ComBoSubCatDs,
		displayField:'drugsubcatdesc',
		mode: 'local', 
		width : 120,
		id:'subcatcomb',
		emptyText:'',
		listWidth : 200,
		valueField : 'drugsubcatrowid',
		emptyText:'ѡ��ҩѧ����...',
		fieldLabel: 'ѡ��ҩѧ����'
	}); 
	
	
	ComBoCat.on(
	'select',
	function(){
		ComBoSubCatDs.proxy = new Ext.data.HttpProxy({url:unitsUrl+'?action=GetPhcSubCatDs&CatDr='+Ext.getCmp("catcomb").getValue(), method:'GET'});
	    ComBoSubCatDs.load();
		}
  	);
	
	//ҩѧС��

    var ComBoMinCatDs = new Ext.data.Store({
		//autoLoad: true,
		proxy :'',
		//proxy : new Ext.data.HttpProxy({
		//	url : unitsUrl
		//			+ '?action=GetPhcMinCatDs',
		//	method : 'POST'
		//}),
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'drugmincatrowid'},['drugmincatdesc','drugmincatrowid'])
				
	});
	

	var ComBoMinCat = new Ext.form.ComboBox({
		store: ComBoMinCatDs,
		displayField:'drugmincatdesc',
		mode: 'local', 
		width : 120,
		id:'mincatcomb',
		emptyText:'',
		listWidth : 200,
		valueField : 'drugmincatrowid',
		emptyText:'ѡ��ҩѧС��...',
		fieldLabel: 'ѡ��ҩѧС��'
	}); 
	
	
	ComBoSubCat.on(
	'select',
	function(){
		ComBoMinCatDs.proxy = new Ext.data.HttpProxy({url:unitsUrl+'?action=GetPhcMinCatDs&SubCatDr='+Ext.getCmp("subcatcomb").getValue(), method:'GET'});
	    ComBoMinCatDs.load();
		}
  	);


	 
	var DrugCatForm=new Ext.Panel( {
	
	  //lableWidth:80,
	  region : 'center',
	  frame :true,
	  layout : "form",
	  labelAlign : 'right',
	  tbar:[OpenDrugCatButton],
	  items : [ComBoCat,ComBoSubCat,ComBoMinCat]
	 }) ;
 
  // define window and show it in desktop
  var DrugCatWindow = new Ext.Window({
    title: 'ҩѧ����',
    width: 400,
    height:200,
    minWidth: 400,
    minHeight: 200,
    layout: 'border',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    items:  [  DrugCatForm]
   //commentitmgrid

    });
    //DrugCatWindow.setPosition(btnobj.getX(), btnobj.getY()));
    DrugCatWindow.show();




///----------------Events----------------


	function SelectOne()
	{
		
		var catdesc="";
		var subcatdesc="";
		var mincatdesc="";
		var catdr="";
		var subcatdr="";
		var mincatdr="";
		var retcatstr="";
		
		catdesc=trim(Ext.getCmp("catcomb").getRawValue());
		catdr=trim(Ext.getCmp("catcomb").getValue());
		subcatdesc=trim(Ext.getCmp("subcatcomb").getRawValue());
		subcatdr=trim(Ext.getCmp("subcatcomb").getValue());
		mincatdesc=trim(Ext.getCmp("mincatcomb").getRawValue());
		mincatdr=trim(Ext.getCmp("mincatcomb").getValue());
			
		if (catdesc!=""){
			retcatstr=catdesc+"@"+catdr;
		}
		else{
		    Ext.Msg.show({title:'ע��',msg:'ҩѧ�����Ǳ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO}); 
			return;
		}
		if (subcatdesc!=""){
			retcatstr=subcatdesc+"@"+subcatdr;
		}
		if (mincatdesc!=""){
			retcatstr=mincatdesc+"@"+mincatdr;
		}
		
		SetDrugCatTxt(retcatstr);

	    DrugCatWindow.close();
	
	}
 
          
 
    
    
    
    




};