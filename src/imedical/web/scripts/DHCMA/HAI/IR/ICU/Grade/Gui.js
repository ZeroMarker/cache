//ICU患者危险等级评定Gui
var objScreen = new Object();
var obj = objScreen;
function InitGradeWin() {
    
  
  	//初始化医院
    $HUI.combobox("#cboHospital",{
		url:$URL+'?ClassName=DHCHAI.BTS.HospitalSrv&QueryName=QryHospListByLogon&ResultSetType=Array&aLogonHospID='+$.LOGON.HOSPID,
		valueField:'ID',
		textField:'HospDesc',
		editable:false,
		onSelect:function(rec){
			obj.cboWard = Common_ComboToLoc('cboWard',rec.ID,"","I","W");
			obj.cboLocation = Common_ComboToLoc("cboLocation",rec.ID,"","I","E");
		},
		onLoadSuccess:function(data){
			// 院区默认选择
			$('#cboHospital').combobox('select',data[0].ID);
		}
	});
  	//初始化年(最近十年)
	var YearList = $cm ({									
		ClassName:"DHCHAI.STATV2.AbstractComm",
		QueryName:"QryYear"
	},false);
	$HUI.combobox("#cboYear",{
		valueField:'ID',
		textField:'Desc',
		editable:false,
		data:YearList.rows
	});
	//初始化月
	var MonthList = $cm ({									
		ClassName:"DHCHAI.STATV2.AbstractComm",
		QueryName:"QryMonth",
		aTypeID:1
	},false);
	$HUI.combobox("#cboMonth",{
		valueField:'ID',
		textField:'Desc',
		editable:false,
		data:MonthList.rows
	});
	
	//ICU危险等级评定表(后台加载)
    obj.gridGrade = $HUI.datagrid("#gridGrade", {
		fit:true,
		title: "ICU危险等级评定",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		singleSelect: true,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		autoRowHeight: false,
		loadMsg: '数据加载中...',
		nowrap: true, 
		fitColumns: true,
		pageSize: 20,
		pageList : [10,20,50,100],
		url:$URL,
		queryParams:{
		    ClassName: "DHCHAI.IRS.ICUGradeSrv",
		    QueryName: "QryIGByMonth",
		    aLocID: "",
		    aYYMM:" "
		},
		columns:[[
			{ field: 'IGGrade', title: '临床危险等级', width: 300, sortable: true },
			{ field: 'IGScore', title: '分值', width: 160, sortable: true },
			{ field: 'IGWeek1', title: $g('第一周')+'(01~07)', width: 180, sortable: true },
			{ field: 'IGWeek2', title: $g('第二周')+'(08~14)', width: 180, sortable: true },
			{ field: 'IGWeek3', title: $g('第三周')+'(15~21)', width: 180, sortable: true },
			{ field: 'IGWeek4', title: $g('第四周')+'(22~28)', width: 180, sortable: true },
			{ field: 'IGWeek5', title: $g('第五周'), width: 180, sortable: true }
		]],
		onDblClickRow:function(rowIndex,rowData){
			//双击打开明细表
		    if (rowIndex > -1) {
			    obj.OpenLayerGradeExt();
			}
		}
	});

	//危险登记明细表
	obj.gridGradeExt = $HUI.datagrid("#gridGradeExt", {
	    fit: true,
	    headerCls: 'panel-header-gray',
	    iconCls: 'icon-resort',
	    rownumbers: true, //如果为true, 则显示一个行号列
	    singleSelect: true,
	    loadMsg: '数据加载中...',
	    pageSize: 999,
	    columns: [[
			{ field: 'PAMrNo', title: '病案号', width: 100, align: 'center'},
            { field: 'PatName', title: '姓名', width: 80, align: 'center' },
            {
                field: 'Sex', title: '性别', width: 40, align: 'center',
                formatter: function (value, row, index) {
                    if (row.Sex == "M") {
                        return $g('男');
                    } else if(row.Sex == "F"){
                        return $g('女');
                    }else{
	                 	return '';
	                }
                }
            },
            { field: 'Age', title: '年龄', width: 50, align: 'center' },
			{ field:"ZY",title:"摘要",align:'center',width:50,
				formatter:function(value,row,index){
					 return '<a href="#" onclick=obj.btnAbstractMsg_Click(\''+row.Paadm+'\')>'+$g('摘要')+'</a>';
				}
			},
            { field: 'Bed', title: '床位号', width: 60, align: 'center'},
            { field: 'PAAdmDate', title: '入院时间', width: 100, align: 'center' },
            { field: 'TransDate', title: '入科时间', width: 100, align: 'center' },
			{
			    field: 'Item1', title: 'A', width: 50, align: 'center',
			    formatter: function (value, row, index) {
			        var CellID = "Item1-" + index;
			        if (value == 1) {
			            return '<span id="' + CellID + '"style="user-select: none; " >' + "✔" + '</span>';
			        }
			        else {
			            return '<span id="' + CellID + '"style="user-select: none; " >' + "" + '</span>';
			        }
			    }
			},
            {
                field: 'Item2', title: 'B', width: 50, align: 'center',
                formatter: function (value, row, index) {
                    var CellID = "Item2-" + index;
                    if (value == 1) {
                        return '<span id="' + CellID + '"style="user-select: none; " >' + "✔" + '</span>';
                    }
                    else {
                        return '<span id="' + CellID + '"style="user-select: none; " >' + "" + '</span>';
                    }
                }
            },
			{
			    field: 'Item3', title: 'C', width: 50, align: 'center',
			    formatter: function (value, row, index) {
			        var CellID = "Item3-" + index;
			        if (value == 1) {
			            return '<span id="' + CellID + '"style="user-select: none; " >' + "✔" + '</span>';
			        }
			        else {
			            return '<span id="' + CellID + '"style="user-select: none; " >' + "" + '</span>';
			        }
			    }
			},
			{
			    field: 'Item4', title: 'D', width: 50, align: 'center',
			    formatter: function (value, row, index) {
			        var CellID = "Item4-" + index;
			        if (value == 1) {
			            return '<span id="' + CellID + '"style="user-select: none; " >' + "✔" + '</span>';
			        }
			        else {
			            return '<span id="' + CellID + '"style="user-select: none; " >' + "" + '</span>';
			        }
			    }
			},
			{
			    field: 'Item5', title: 'E', width: 50, align: 'center',
			    formatter: function (value, row, index) {
			        var CellID = "Item5-" + index;
			        if (value == 1) {
			            return '<span id="' + CellID + '"style="user-select: none; " >' + "✔" + '</span>';
			        }
			        else {
			            return '<span id="' + CellID + '"style="user-select: none; " >' + "" + '</span>';
			        }
			    }
			},
			{ field: 'AssertUser', title: '评估人', width: 100, align: 'center' }

	    ]],
	    onClickCell: function (Index, field, value) {
	        for (var i = 1; i <= 5; i++) {
	            var CellId = "#Item" + i + "-" + Index;
	            if (field.indexOf(i) > -1) {
	                var text = $(CellId).text();
	                if (text == "") $(CellId).text("✔");
	                if (text == "✔") $(CellId).text("");
	            }
	            else {
	                $(CellId).text("");
	            }
	        }
	    }
	});		
	InitGradeWinEvent(obj);
	obj.LoadEvent();     //初始化信息
	return obj;
}