/** 
 * 模块: 	 配液中心统计报表
 * 编写日期: 2018-03-27
 * 编写人:   yunhaibao
 */
var PIVAREPORT={
	tabGzl:"DHCST.PIVA.REPORT.WORKSTAT.csp", 		  // 配液工作量统计
	tabPivaQuantity:"DHCST.PIVA.REPORT.QUANTITY.csp", // 配液量统计
	tabPivaOeStat:"DHCST.PIVA.REPORT.OESTAT.csp",     // 配伍统计
	tabRefSuccess:"DHCST.PIVA.REPORT.REFSUCCESS.csp", // 干预医嘱统计
	tabPivaStat:"DHCST.PIVA.REPORT.PIVASTAT.csp"  	  // 配液状态一览
}
var SessionLoc=session['LOGON.CTLOCID'];
var SessionUser=session['LOGON.USERID'];
$(function(){
	InitDict();
	$('#tabsCalcu').tabs({   
		border:false,   
		onSelect:function(title){  

		}   
  	});	
	$('#btnFind').on("click",Query);
  	$("#tabWardBat").append('<iframe id="'+"tabWardBatFrame"+'"></iframe>');
	$("#tabWardBatFrame").attr("src",PIVAREPORT['tabGzl'])
	//InitPivasSettings();
});
function InitDict(){
	// 配液中心
	PIVAS.ComboBox.Init(
		{Id:'cmbPivaLoc',Type:'PivaLoc'},
		{
			editable:false,
			onLoadSuccess: function(){   
		    },
		    onSelect:function(data){

			},
			width:214
		}
	);
	// 科室组
	PIVAS.ComboBox.Init({Id:'cmbLocGrp',Type:'LocGrp'},{width:214});
	// 病区
	PIVAS.ComboBox.Init({Id:'cmbWard',Type:'Ward'},{width:214});
	// 医嘱优先级
	PIVAS.ComboBox.Init({Id:'cmbPriority',Type:'Priority'},{width:214});
	// 集中配制
	PIVAS.ComboBox.Init({Id:'cmbWorkType',Type:'PIVAWorkType'},{width:214});
	// 药品
	PIVAS.ComboGrid.Init({Id:'cmgIncItm',Type:'IncItm'},{width:214});
	// 打包
	PIVAS.ComboBox.Init({Id:'cmbPack',Type:'YesOrNo'},{width:214});
	// 批次
	PIVAS.BatchNoCheckList({Id:"DivBatNo",LocId:SessionLoc,Check:true,Pack:false});
	// 配液状态
	PIVAS.ComboBox.Init({Id:'cmbPivaStat',Type:'PIVAState'},{
		editable:false,
		onLoadSuccess: function(){
		//	$(this).combobox('showPanel');
		},
		width:214
	});
}

/// 查询
function Query(){
	alert(1)
}
