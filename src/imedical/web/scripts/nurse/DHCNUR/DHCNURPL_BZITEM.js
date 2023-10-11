/**
 * @author Administrator
 */
 
 
var grid;
var arrgrid = new Array();
	var arrgridM = new Array();
	var KNurseNameStore = new Ext.data.JsonStore({
			data :arrgridM,
			fields : ['id', 'desc']		
		});
var arrtim=new Array();
var GetQueryData = document.getElementById('GetQueryData');
//var a = cspRunServerMethod(GetQueryData.value, "Nur.DHCNurLinkCode.GetModel", "" , "AddTim");
var storetim = new Ext.data.JsonStore({
			data : arrtim,
			fields : ['idv', 'des']
		});
function AddTim(str)
{
	var obj = eval('(' + str + ')');
	arrtim.push(obj);
}
var arrgridnurse = new Array();
var storenurse = new Ext.data.JsonStore({
			data :arrgridnurse,
			fields : ['desc', 'id']
		});
var patward = new Ext.form.ComboBox({
			id : 'patward',
			//hiddenName : 'region1',
			fieldLabel : '标准模板',
			store : storenurse,
			width : 80,
            ///fieldLabel : '区',
			valueField : 'id',
			triggerAction: "all",
			displayField : 'desc',
			value:"",
			allowBlank : true,
			mode : 'local'
		});
var window1=""
function ModeList() {
	//alert(window1)
	if (window1!="")
	{
		window1.close()
	}
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	//alert(len)
	if (len < 1) 
	{
		 //Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons:
		// Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	} 
	else 
	{
		myId = rowObj[0].get("par");
	}
	var arr = new Array();
	// 录入界面
	var DHCNURPL_INT136=new Ext.data.JsonStore({data:[],fields:['ItmName','ItmCode','ItmFlag','par','rw']});
	var a = cspRunServerMethod(pdata1, "", "DHCNURPL_IN", EpisodeID, "");   
    arr = eval(a);
	for(var i = 0;i<arr.length;i++)
	{
		if(arr[i].name=='LinkItemCode')
		{
			combo.x=arr[i].x
			combo.y=arr[i].y
			combo.width=arr[i].width
			arr[i]=combo;
			//alert(arr[i].width)
			//alert(arr[i].x)
		}
		
	}
   window1 = new Ext.Window({
				title : '质控维护',
				width : 700,
				height : 450,
					x:10,
				y:10,
				autoScroll : true,
				layout : 'absolute',
				maximizable:true,
				minimizable:true,
				constrain:true,
				plain:true,
				// plain: true,
				// modal: true,
				// bodyStyle: 'padding:5px;',
				// /buttonAlign: 'center',
				items : arr,
				buttons : []
			});
		setvalue()
		var itmgrid = Ext.getCmp("itmgrid");
		 var bbar = itmgrid.getBottomToolbar ();
	bbar.hide();
		//alert(itmgrid)
		var but1=Ext.getCmp("itmgridbut1");
	    but1.setText("新建");
	    but1.on('click',itmadditm)
	    var but=Ext.getCmp("itmgridbut2");
	    but.setText("保存");
	    but.on('click',save)
		var obj = Ext.getCmp("BtnClear"); //保存
	//alert(obj)
	obj.hide()
		window1.show();
		var Saveobj = Ext.getCmp("BtnSave"); //保存
	    Saveobj.on('click',additm)
		var AssCodeobj = Ext.getCmp("AssCode");
        AssCodeobj.disable()
		return	
}
function itmadditm()
{ 
	//alert(myId)
	if (myId=="") return
	var itmgrid = Ext.getCmp("itmgrid");
    var AssNameval = Ext.getCmp("AssName").getValue();
    //alert(AssNameval)
  	var Plant = Ext.data.Record.create([
	{name:'ItmName'}, 
	{name:'ItmCode'},
	{name:'ItmFlag'},
	{name:'par'},
	{name:'rw'}
      ]);
    var count = itmgrid.store.getCount(); 
    var r = new Plant({par:myId,ItmName:AssNameval,ItmFlag:"Y"}); 
    itmgrid.store.commitChanges(); 
    itmgrid.store.insert(0,r); 
	return;
}
var haval = new Hashtable(); //签名hashitable
function setvalue()
{   		
			var getstr=tkMakeServerCall("Nur.DHCNurAssess","getVal",myId)
			var zkstr=getstr.split('^')
			//alert(zkstr)
			haval = new Hashtable(); //签名hashitable
			sethashvalue(haval,zkstr);		
		  //加载多选元素
	var SJNameobj = Ext.getCmp("Item3"); //戈登分类
	if (SJNameobj != null) 
	{	
		arraymain = new Array();
		tkMakeServerCall("Nur.DHCNurGordon","GetItmList","addgd")
		SJNameobj.store.loadData(arraymain);
		SJNameobj.setValue(haval.items("AssCatCode"))
	}
	var SJNameobj = Ext.getCmp("Item1"); //数据类型
	SJNameobj.setValue(haval.items("AssType"))
	var SJNameobj = Ext.getCmp("Item2"); //选择方式
	SJNameobj.setValue(haval.items("AssSelType"))
	var SJNameobj = Ext.getCmp("Item4"); //戈登分类
	SJNameobj.setValue(haval.items("AssDesc"))
	var SJNameobj = Ext.getCmp("Item5"); //戈登分类
	SJNameobj.setValue(haval.items("AssPositiveRange"))
	var SJNameobj = Ext.getCmp("AssName"); //戈登分类
	SJNameobj.setValue(haval.items("AssName"))
	var SJNameobj = Ext.getCmp("AssCode"); //戈登分类
	SJNameobj.setValue(haval.items("AssCode"))
	itmfind()
	    
	 
		
  
}
function BodyLoadHandler() {
	setsize("mygridpl", "gform", "mygrid");
		 //fm.doLayout();
		//but.hide();
		grid = Ext.getCmp('mygrid');
		var len = grid.getColumnModel().getColumnCount();
		for (var i = 0; i < len; i++) {
			if (grid.getColumnModel().getDataIndex(i) == 'par') {
				grid.getColumnModel().setHidden(i, true);
			}
		}

		var but1=Ext.getCmp("mygridbut1");
	  but1.hide()
	  var but=Ext.getCmp("mygridbut2");
	  but.hide()
	  grid.on('rowdblclick',ModeList);
	  var mydate = new Date();
	  var tobar = grid.getTopToolbar();
	  //tobar.addItem('标准模板',Bzmb)
      tobar.addItem('戈登分类',patward,'-');	
	  var tbar2=new Ext.Toolbar({	});		
	  //tbar2.addItem('模板类型',Type)
	  //tbar2.addItem('-','数据绑定',Source)

	  tobar.addButton({
	  //className : 'new-topic-button',
	  icon:'../images/uiimages/edit_add.png',
	  text : "增加",
	  handler : Add,
	  id : 'ADDSAVE'
	  });		
     
		tobar.addItem("-"); 
		tobar.addButton({
			//className : 'new-topic-button',
			icon:'../images/uiimages/edit_remove.png',
			text : "删除",
			handler : typdelete,
			id : 'mygridDelete3'
		});
		tobar.addItem("-"); 
		tobar.addButton({
			//className : 'new-topic-button',
			icon:'../images/uiimages/search.png',
			text : "查询",
			handler : find,
			id : 'find'
		});
		tobar.addItem("-"); 
		/*
		tbar2.addItem("-"); 
		tbar2.addButton({
			className : 'new-topic-button',
			text : "数据源维护",
			handler : source,
			id : 'source'
		});
*/
	  tbar2.render(grid.tbar); 
	    var bbar = grid.getBottomToolbar ();
	  bbar.hide();
	  var bbar2 = new Ext.PagingToolbar({
		pageSize:30,
		store:grid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	bbar2.render(grid.bbar);
		tobar.doLayout();
    grid.addListener('rowclick', function()
    {
   	  var grid = Ext.getCmp('mygrid');
   	  var objRow=grid.getSelectionModel().getSelections();
	    if (objRow.length == 0) {
		     return;
	    }
	    else{		
	       var grid = Ext.getCmp("mygrid");
	       var rowObj = grid.getSelectionModel().getSelections();	      
	      
	    }
	  }
   );
   var maincode = Ext.getCmp("patward");
    arrgridnurse = new Array();
	tkMakeServerCall("Nur.DHCNurDiagnos","GetItmList","addmain")
	maincode.store.loadData(arrgridnurse);
	maincode.on('select',find)
  //alert(Sourceobj)
  arraybzmb= new Array();
   var bbar = grid.getBottomToolbar ();
	 // bbar.hide();
  //tkMakeServerCall("NurEmr.EmrCodeDic","GetItmList","addbzmb")
  //Sourceobj.store.loadData(arraybzmb); 
  find();
}

function source()
{  
	 var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNURIF_SOURCE&EpisodeID="  ;//"&DtId="+DtId+"&ExamId="+ExamId
	 //alert(lnk)
	 var wind22455=window.open(lnk,"htmsource",'left=200,top=100,toolbar=no,location=no,directories=no,resizable=yes,width=800,height=500');
}
var selectid=""
function moudsave(){
	
	}
function addmain(a, b) {
	//alert(a)
	arrgridnurse.push({
				id : a,
				desc : b
			});
}
function clearinfo(){
	     
	       var HLCode = Ext.getCmp("HLCode");
	       HLCode.setValue("");	
	     
		     selectid=""
		     var ADDSAVE = Ext.getCmp("ADDSAVE");
		     ADDSAVE.setDisabled(false)
		     var exchange = Ext.getCmp("exchange");
		     exchange.setDisabled(true)	  
		     var mygridDelete3 = Ext.getCmp("mygridDelete3");
		     mygridDelete3.setDisabled(true)
		     
	}
function additm()
{
    var Item1val = Ext.getCmp("Item1").getValue() //数据类型
    var Item2val = Ext.getCmp("Item2").getValue() //选择方式
    var Item3val = Ext.getCmp("Item3").getValue() //戈登分类
    var Item4val = Ext.getCmp("Item4").getValue() //描述
    var Item5val = Ext.getCmp("Item5").getValue() //阳性范围
    var AssNameval = Ext.getCmp("AssName").getValue() //阳性范围
    var AssCodeval = Ext.getCmp("AssCode").getValue() //阳性范围
	if ((Item1val=="")&&(myId==""))
	{
		 alert("数据类型不能为空！")
		 return
	}
	if (Item2val=="")
	{
		alert("选择方式不能为空！")
		 return
	}
	if (Item3val=="")
	{
		 alert("戈登分类不能为空")
		 return		
	}
            ret=""
			ret = ret + "Text|" + AssNameval + "^";
			ret = ret + "Code|" + AssCodeval + "^";
			ret = ret + "Desc|" + Item4val + "^";
			ret = ret + "Group|"  + "^";
			ret = ret + "Type|" + Item1val + "^";
			ret = ret + "Range|" + Item5val + "^";
			ret = ret + "SelType|" + Item2val + "^";
			ret = ret + "Cate|" + Item3val + "^";
			//ret = ret + "EmrCode|" + bzCode + "^";
			//ret = ret + "EmrCodeName|" + SJName + "^";
	  // alert(ret)
     	//alert(myId)
	   var ret=tkMakeServerCall("Nur.DHCNurAssess","Save",ret,myId)
	   if (ret=="err")
	   {
           alert("该分类下该代码已经存在！")
           return;
	   }else{
	   	  myId=ret
	   }
	   find()
	   //alert(myId)

}
//适用科室
  var locdata = new Array();
	var store=new Ext.data.JsonStore({data:[],fields: ['desc', 'id']});
	var combo={
		name:'LinkItemCode',
		id:'LinkItemCode',
		tabIndex:'0',
		x:x1,
		y:y1,
		height:121,
		width:152,
		xtype:'combo',
		store:store,
		editable:true,
		displayField:'desc',
		valueField:'id',
		allowBlank: true,
		triggerAction: 'all',
		tpl:'<tpl for="."><div class="x-combo-list-item"><span><input type="checkbox" {[values.check?"checked":""]}  value="{[values.id]}" /></span><span >{desc}</span></div></tpl>',
		emptyText:'请选择',
		selectOnFocus:true,
    //applyTo:'local-descs',
		mode:'local',
		onSelect : function(record, index){
            if(this.fireEvent('beforeselect', this, record, index)){
                record.set('check',!record.get('check'));
                var str=[];//页面显示的值
                var strvalue=[];//传入后台的值
                selectedlinkitm=""
                this.store.each(function(rc){
                    if(rc.get('check')){
                        str.push(rc.get('desc'));
                        strvalue.push(rc.get('id'));
                        if (selectedlinkitm=="")
                        {
                           selectedlinkitm=rc.get('id')
                        }else{
                        	 selectedlinkitm=selectedlinkitm+","+rc.get('id')
                        }
                        
                    }                  
                });
                // alert(selectedlinkitm)
                //alert(str)
                this.setValue(str.join());
                this.value=strvalue.join();
                this.valueId= strvalue.join();
              			
                 //this.collapse();
                this.fireEvent('select', this, record, index);
                
                //findperson (record.get('id'),record,index);
                //if (this.valueId==null||this.valueId==''||this.valueId.split(",").length>1)
                //{
                 	//clearperson('RequestConDoc');
                //}
             }
        },
		value:'',
		valueId:''
	};
	//质控关联项
	var onezkitemdesc="";
	var descseqno=0;
var logonht=1;
var x1=0,y1=500;
var x2=0,y2=0;
var x3=0,y3=0;
var x4=0,y4=0;
var myId=""
var selectedbzitm="" //x
var selectedlinkitm="" //guanlian yuan su
function Add()
{
	myId = "";
	var arr = new Array();
	var DHCNURPL_INT136=new Ext.data.JsonStore({data:[],fields:['ItmName','ItmCode','ItmFlag','par','rw']});
    var a = cspRunServerMethod(pdata1, "", "DHCNURPL_IN", EpisodeID, "");   
	//alert(a)
    arr = eval(a);
	for(var i = 0;i<arr.length;i++)
	{
		if(arr[i].name=='LinkItemCode')
		{
			combo.x=arr[i].x
			combo.y=arr[i].y
			combo.width=arr[i].width
			arr[i]=combo;			
		}
	}
	 window1 = new Ext.Window({
				title : '模板元素对照',
				width : 700,
				height : 450,
				x:10,
				y:10,
				autoScroll : true,
				layout : 'absolute',
				// plain: true,
				// modal: true,
				// bodyStyle: 'padding:5px;',
				// /buttonAlign: 'center',
				items : arr,
				buttons : []
			});
	var Saveobj = Ext.getCmp("BtnSave"); //保存
	Saveobj.on('click',additm)
	//Modeobj.on('click',Save)
	var SJNameobj = Ext.getCmp("BZCode"); //修改
    var obj = Ext.getCmp("BtnClear"); //保存
	//alert(obj)
	obj.hide()
	if (SJNameobj != null) 
	{	
		arraymain = new Array();
		//tkMakeServerCall("NurEmr.BLSJSBInterface","getMaincode","addmain")
		tkMakeServerCall("Nur.DHCNurLinkCode","GetLinkCode","addmain")
		SJNameobj.store.loadData(arraymain);
		SJNameobj.on('select', findlinkitm);
		//SJNameobj.on('select', findsjitms);
		//SJNameobj.on('select', finditms);
		//Dep.on('change', GetDepModelSet,this);
	}
    var SJNameobj = Ext.getCmp("Item3"); //戈登分类
    var gdval = Ext.getCmp("patward").getValue(); //戈登分类
	if (gdval!="")  SJNameobj.setValue(gdval)
	if (SJNameobj != null) 
	{	
		arraymain = new Array();
		//alert(122)
		//tkMakeServerCall("NurEmr.BLSJSBInterface","getMaincode","addmain")
		tkMakeServerCall("Nur.DHCNurGordon","GetItmList","addgd")
		SJNameobj.store.loadData(arraymain);
		//SJNameobj.on('select', findlinkitm);
	}
    var itmgrid = Ext.getCmp("itmgrid"); //修改
	itmgrid.getBottomToolbar().hide()
    var itmbut1=Ext.getCmp("itmgridbut1");
	itmbut1.on('click',itmadditm);
	var itmbut=Ext.getCmp("itmgridbut2");
	itmbut.setText("保存");
	itmbut.on('click',save);
	//var ItemName = Ext.getCmp("ItemName");
	//ItemName.on('select', setname);
	window1.show();
	var maincodeobj = Ext.getCmp("patward");
	var BZCodeobj = Ext.getCmp("BZCode");
	if (maincodeobj.getValue()!="")
	{
	   //BZCodeobj.setValue(maincodeobj.getValue());
	   //findlinkcode()
    }
	//var LinkHLCodeobj = Ext.getCmp("LinkHLCode");
	//alert(LinkHLCodeobj)
	//LinkHLCodeobj.on('select', findlinkitm);
	
}
function save(){
	var itmgrid=Ext.getCmp("itmgrid");
    var store = itmgrid.store;
	var rowCount = store.getCount(); //记录数
	var cm = itmgrid.getColumnModel();
	var colCount = cm.getColumnCount();
	var list = [];
	var rowObj = itmgrid.getSelectionModel().getSelections();
		var len = rowObj.length;
		for (var r = 0;r < len; r++) {
		list.push(rowObj[r].data);
	}		
	//for (var i = 0; i < store.getCount(); i++) {
	//	list.push(store.getAt(i).data);
	//	//	debugger;
	//}	  
	for (var i = 0; i < list.length; i++) {
	  var obj=list[i];
	  var str="";
	  var CareDate="";
	  var CareTime="";
	  var flag="0";
		for (var p in obj) {
			var aa = formatDate(obj[p]);										
			if (p=="") continue;
			if (aa == "") 
			{
			    str = str + p + "|" + DBC2SBC(obj[p]) + '^';
			}else
			{
			  	str = str + p + "|" + aa + '^';	
			}
		}
		//alert(str)
		tkMakeServerCall("Nur.DHCNurAssessItem","Save",str)
	    itmfind()
	}

}
function itmfind () {
	var itmgrid = Ext.getCmp("itmgrid");
	var GetQueryData=document.getElementById('GetQueryData2');
	arrgrid=new Array();
	//var mbobj = Ext.getCmp("patward");
	//var parr=mbobj.getValue()
	var parr =myId+ "^"+"^"+"^"+"^";
	//alert(session['LOGON.CTLOCID']);
	var a = cspRunServerMethod(GetQueryData.value, "Nur.DHCNurAssessItem:CRItem", "parr$"+parr, "AddRec");
  //alert(a);
    itmgrid.store.loadData(arrgrid);  
}
function DBC2SBC(str)   
{
	var result = '';
	if ((str)&&(str.length)) {
		for (var i = 0; i < str.length; i++) {
			var code = str.charCodeAt(i);
			if (code >= 65281 && code <= 65373) {
				result += String.fromCharCode(str.charCodeAt(i) - 65248);
			}
			else {
				if (code == 12288) {
					result += String.fromCharCode(str.charCodeAt(i) - 12288 + 32);
				}
				else {
					result += str.charAt(i);
				}
			}
		}
	}
	else{
		result=str;
	}  
	return result;   
}

function addgd(a, b) {
	//alert(a)
	arraymain.push({
				id : a,
				desc : b
			});
}
//查询护理模板元素
function findlinkitm(p, record, index) {
	var sjcode = Ext.getCmp("BZCode").getValue();
	//var LinkHLCodeval = Ext.getCmp("LinkHLCode").value;
	arraysub = new Array();	
	tkMakeServerCall("NurEmr.BLSJSBInterface","GetCodeList",sjcode,"",sjcode,"addsub") //护理模板元素
	var LinkItemCodeobj = Ext.getCmp("LinkItemCode");
	LinkItemCodeobj.store.loadData(arraysub);	

    //var ItemNameobj = Ext.getCmp("ItemName")
	//ItemNameobj.setValue("")
	//arraysub = new Array();
   // tkMakeServerCall("NurEmr.BLSJSBInterface","getSubcode",sjcode,LinkHLCodeval,"1","addsub")  //筛选
	//ItemNameobj.store.loadData(arraysub);

}

function find()
{	
	
    var grid = Ext.getCmp("mygrid");
	var GetQueryData=document.getElementById('GetQueryData2');
	arrgrid=new Array();
	var mbobj = Ext.getCmp("patward");
	//var parr=mbobj.getValue()
	var parr =mbobj.getValue()+ "^"+"^"+"^"+"^";
	//alert(session['LOGON.CTLOCID']);
	/*
	var a = cspRunServerMethod(GetQueryData.value, "Nur.DHCNurAssess:CRItem", "parr$"+parr, "AddRec");
  //alert(a);
    grid.store.loadData(arrgrid);   
  */
      var mygrid = Ext.getCmp("mygrid");
   mygrid.store.on("beforeLoad",function(){   
       mygrid.store.baseParams.parr=parr;    //传参数，根据原来的方式修改
   });    
   //mygrid.getStore().addListener('load',handleGridLoadEvent); //护理记录表格需要：日期转换及出入量统计行加颜色
   mygrid.store.load({
    	params:{
    		start:0,
    		limit:30
    	}	
   })

 
}
function AddRec(str)
{
	//var a=new Object(eval(str));
	var obj = eval('(' + str + ')');
	arrgrid.push(obj);
	//debugger;
}
function find2()
{	
    var grid = Ext.getCmp("mygrid");
	var GetQueryData=document.getElementById('GetQueryData');
	arrgrid=new Array();
	//alert(session['LOGON.CTLOCID']);
	var a = cspRunServerMethod(GetQueryData.value, "User.DHCNURMenu:CRItem2", "parr$", "AddRec2");
  //alert(a);
  grid.store.loadData(arrgrid);   
}
function AddRec2(str)
{
	//var a=new Object(eval(str));
	var obj = eval('(' + str + ')');
	arrgrid.push(obj);
	//debugger;
}
function typdelete() {
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	var list = [];
 
	 var rw=""
	if (len == 0) {
		Ext.Msg.alert('提示', "请先选择一行!");
		return;
	};
	for (var r = 0;r < len; r++) 
{
			list.push(rowObj[r].data);
}
 
for (var i = 0; i < list.length; i++) 
{
			  var obj=list[i];
 
			  rw=obj["par"];
}
 

        if (rw==undefined) 
	    {
		   Ext.Msg.alert('提示', "请先选择有效行!");
		   return;
	    };
		
		  Ext.Msg.show({    
	       title:'确认一下',    
	       msg: '确定要删除吗？',    
	       buttons:{"ok":"是     ","cancel":"  否"},
	       fn:  function(btn, text){    
	            if (btn == 'ok'){   
	         var ee=tkMakeServerCall("Nur.DHCNurAssess","QtDelete",rw)
		     if (ee != "0") {
		        alert(ee);
		        return;
		      }
		   find()	            
	       }
	        },    
	       animEl: 'newbutton'   
	       });
}
function clearscreen() {
	var typ = Ext.getCmp("typsys");
	if (typ) typ.setValue("");
}
function diffDate(val,addday){
	var year=val.getYear();
	var mon=val.getMonth();
	var dat=val.getDate()+addday;
	var datt=new Date(year,mon,dat);
	return formatDate(datt);
}
function getDate(val)
{
	var a=val.split('-');
	var dt=new Date(a[0],a[1]-1,a[2]);
	return dt;
}
function formatDate(value){
  	try
	{
	   return value ? value.dateFormat('Y-m-d') : '';
	}
	catch(err)
	{
	   return '';
	}
 };