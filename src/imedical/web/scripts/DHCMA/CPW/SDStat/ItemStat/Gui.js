//页面Gui
objScreen = new Object();
function InitItemStatWin(){
	obj=objScreen
	obj.EntityID=""
	obj.EntityDesc="";
    $.parser.parse(); 
    var HospID=session['DHCMA.HOSPID']
    //选择统计病种导航窗
	$('#winQCEntity').dialog({
		title: '指标统计',
		iconCls:'icon-w-list',
		closable: false,
		modal: true
	});
	$cm({
		ClassName:"DHCMA.CPW.SDS.QCEntitySrv",
		QueryName:"QryQCEntity"	
		},function(data){
			var dicList=data.rows
			var len=dicList.length,columns=4,listHtml="<div>"
			var per = Math.round((1/columns) * 100) + '%';   //每列所在百分比
			var count = parseInt(len/columns)+1;
			for (var index =0; index< count; index++) {
				var listlen=(((index+1)*columns)<len) ? (index+1)*columns : len;
				listHtml +="<div style='padding:20px'>"; 
				for (var dicIndex = index*columns; dicIndex < listlen; dicIndex++) {	
					var dicSubList = dicList[dicIndex];
					listHtml += " <div style='padding:0px;text-align:center;float:left;width:"+per+"'><a style='cursor:pointer' onClick='objScreen.LoadItemSta("+dicSubList.BTID+",\""+dicSubList.BTDesc+"\",\""+dicSubList.BTAbbrev+"\")' id="+dicSubList.BTID+">"+"<img src='../scripts/DHCMA/img/"+dicSubList.BTAbbrev+".png'/><p>"+" "+dicSubList.BTDesc+"</p></a></div>";  
				} 
				listHtml +="</div>"
				listHtml +="<div style='clear:both'></div>"
			}
			listHtml +="</div>"
			$('#QCEntityList').html(listHtml); 
			$.parser.parse('#QCEntityList');  //解析checkbox
		})

	//初始查询条件
	$HUI.combobox('#cboHospital',
	    {
			url:$URL+'?ClassName=DHCMA.Util.EPS.HospitalSrv&QueryName=QryHospInfo&ResultSetType=Array&aHospID='+HospID,
			valueField:'OID',
			textField:'Desc',
	    	onSelect:function(rd){
		    	HospID=rd.OID;
		    	var url =$URL+'?ClassName=DHCMA.Util.EPS.LocationSrv&QueryName=QryLocInfo&ResultSetType=Array&aHospID='+HospID+'&aAdmType=I';
        		$('#cboLocation').combobox('setValue','');
        		$('#cboLocation').combobox('reload', url);
		   },
		   onLoadSuccess:function(){
			   	Common_SetValue('cboHospital',HospID);
			   	$('#search').click();
			   }		    
	    } )	
	$HUI.combobox('#cboLocation',
	    {
			url:$URL+'?ClassName=DHCMA.Util.EPS.LocationSrv&QueryName=QryLocInfo&ResultSetType=Array&aHospID='+HospID+'&aAdmType=I',
			valueField:'OID',
			textField:'Desc'		    
	    })
	
    /*obj.cboHospital = Common_ComboToSSHosp("cboHospital",SSHospCode,"SD");
	//医院科室联动
	$HUI.combobox('#cboHospital',{
	    onSelect:function(rows){
		    var HospID=rows["CTHospID"];
		    Common_ComboToLoc("cboLocation","E","","",HospID);  
	    }
    });*/
    $HUI.combobox('#cboDateType',{
    	valueField:'id',
		textField:'text',
		selectOnNavigation:true,
		panelHeight:'auto',
		editable:false,
		data:[
			{id:'',text:'-统计时间类型-'},
			{id:'1',text:'按年季度'},
			{id:'2',text:'按入单日期'}
		],
		onSelect:function(row){
			if (row.id=='2'){
					$('#sDateFrom').show();
					$('#sDateTo').show();
					$('#sQuarter').hide();
					$('#cboQuarter').combobox('setValue','');
					$('#sYear').hide();	
					$('#cboYear').combobox('setValue','');
			}else{
					$('#sYear').show();	
					$('#sDateFrom').hide();
					$('#DateFrom').datebox('setValue','');
					$('#sDateTo').hide();
					$('#DateTo').datebox('setValue','');
				}
			}
    })
    $m({
		ClassName:'DHCMA.CPW.SDS.Stat.StatService',
		MethodName:'GetDefaultYears'	    
	},function(Jsonstr){
		var Jsondata=eval(Jsonstr)
		$HUI.combobox('#cboYear',{
		    valueField:'id',
			textField:'text',
			selectOnNavigation:false,
			panelHeight:"auto",
			editable:false,
			data:Jsondata,
			onSelect:function(row){
			    if (row.id==""){
				    $('#sQuarter').hide();
				    $('#Quarter').combobox('setValue','');
				}else{
					$('#sQuarter').show();
				}
		    }
    	});
	})
	$('#cboQuarter').combobox({
	    valueField:'id',
		textField:'text',
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'',text:'-季度-'},
			{id:'1',text:'第一季度'},{id:'2',text:'第二季度'},
			{id:'3',text:'第三季度'},{id:'4',text:'第四季度'}
		]
    });
	InitItemStatWinEvent(obj);
	//初始化查询条件
	obj.InitSearch();	
	return obj;
}