//页面Event
function InitGradeWinEvent(obj){
	CheckSpecificKey();
	$("#startDate").change(function(){
		obj.gridGrade.ajax.reload();
	});
	
    //双击一列
	obj.gridGrade.on('dblclick', 'tr', function(e) {
		obj.Layer();
	});
	//编辑
	$("#btnEdit").on('click', function(){
		obj.Layer();
	});
	
	//导出
	$("#btnExport").on('click', function(){
		obj.gridGrade.buttons(0,null)[0].node.click();	
	});
	new $.fn.dataTable.Buttons(obj.gridGrade, {
		buttons: [
			{
				extend: 'excel',
				text:'导出',
				title:"ICU危险等级登记调查表"
				,footer: true
				,exportOptions: {
					columns: ':visible'
					,width:50
					,orthogonal: 'export'
				},
				customize: function( xlsx ) {
					var sheet = xlsx.xl.worksheets['sheet.xml'];
					
				}
			}
		]
	});

	obj.Layer = function(){
		$.form.SetValue("txtIGItem1","");
		$.form.SetValue("txtIGItem2","");
		$.form.SetValue("txtIGItem3","");
		$.form.SetValue("txtIGItem4","");
		$.form.SetValue("txtIGItem5","");
		$.form.SetValue("txtIGItem6","");
		$.form.SetValue("txtIGItem7","");
		$.form.SetValue("txtIGItem8","");
		$.form.SetValue("txtIGItem9","");
		$.form.SetValue("txtIGItem10","");
		$.form.SetValue("txtIGItem11","");
		$.form.SetValue("txtIGItem12","");
		$.form.SetValue("txtIGItem13","");
		$.form.SetValue("txtIGItem14","");
		$.form.SetValue("txtIGItem15","");
		$.form.SetValue("txtIGItem16","");
		$.form.SetValue("txtIGItem17","");
		$.form.SetValue("txtIGItem18","");
		$.form.SetValue("txtIGItem19","");
		$.form.SetValue("txtIGItem20","");
		
		var LocDr   = $.form.GetValue("ulLoc");
	    var Date    = $.form.GetValue("startDate");
	    var Year    = Date.split('-')[0];
	    var Month   = Date.split('-')[1];
		var ItemList=$.Tool.RunServerMethod("DHCHAI.IRS.ICUGradeSrv","GetGradeID",LocDr,Year,Month);
		var len=ItemList.split(",").length;
        if (len>1) {
			for (var indx = 1; indx < len; indx++) {
		 		var ItemID =ItemList.split(",")[indx];
				var ItemInfo =$.Tool.RunServerMethod("DHCHAI.IRS.ICUGradeSrv","GetGradeString",ItemID);
			    if (indx==1) {
				    $.form.SetValue("txtIGItem1",ItemInfo.split("^")[1]);
					$.form.SetValue("txtIGItem2",ItemInfo.split("^")[2]);
					$.form.SetValue("txtIGItem3",ItemInfo.split("^")[3]);
					$.form.SetValue("txtIGItem4",ItemInfo.split("^")[4]);
					$.form.SetValue("txtIGItem5",ItemInfo.split("^")[5]);
			    }
			    if (indx==2) {
				    $.form.SetValue("txtIGItem6",ItemInfo.split("^")[1]);
					$.form.SetValue("txtIGItem7",ItemInfo.split("^")[2]);
					$.form.SetValue("txtIGItem8",ItemInfo.split("^")[3]);
					$.form.SetValue("txtIGItem9",ItemInfo.split("^")[4]);
					$.form.SetValue("txtIGItem10",ItemInfo.split("^")[5]);
			    }
			    if (indx==3) {
				    $.form.SetValue("txtIGItem11",ItemInfo.split("^")[1]);
					$.form.SetValue("txtIGItem12",ItemInfo.split("^")[2]);
					$.form.SetValue("txtIGItem13",ItemInfo.split("^")[3]);
					$.form.SetValue("txtIGItem14",ItemInfo.split("^")[4]);
					$.form.SetValue("txtIGItem15",ItemInfo.split("^")[5]);
			    }
			    if (indx==4) {
				    $.form.SetValue("txtIGItem16",ItemInfo.split("^")[1]);
					$.form.SetValue("txtIGItem17",ItemInfo.split("^")[2]);
					$.form.SetValue("txtIGItem18",ItemInfo.split("^")[3]);
					$.form.SetValue("txtIGItem19",ItemInfo.split("^")[4]);
					$.form.SetValue("txtIGItem20",ItemInfo.split("^")[5]);
			    }
			}
		}
		
		layer.open({
		  type: 1,
		  zIndex: 100,
		  area: '650px',
		  title: 'ICU危险等级登记', 
		  content: $('#layer'),
		  btn: ['保存','关闭'],
		  btnAlign: 'c',
		  yes: function(index, layero){
			  obj.Layer_Save();
		   }
		});
	}
	
	obj.Layer_Save = function(){
		var LocDr   = $.form.GetValue("ulLoc");
	    var Date    = $.form.GetValue("startDate");
	    var Year    = Date.split('-')[0];
	    var Month   = Date.split('-')[1];
		var ItemList=$.Tool.RunServerMethod("DHCHAI.IRS.ICUGradeSrv","GetGradeID",LocDr,Year,Month);
		var ItemID1 =(ItemList.split(",")[1] ? ItemList.split(",")[1]:'');
		var ItemID2 =(ItemList.split(",")[2] ? ItemList.split(",")[2]:'');
		var ItemID3 =(ItemList.split(",")[3] ? ItemList.split(",")[3]:'');
		var ItemID4 =(ItemList.split(",")[4] ? ItemList.split(",")[4]:'');
		
		var IGItem1 = $.form.GetValue("txtIGItem1");
		var IGItem2 = $.form.GetValue("txtIGItem2");
		var IGItem3 = $.form.GetValue("txtIGItem3");
		var IGItem4 = $.form.GetValue("txtIGItem4");
		var IGItem5 = $.form.GetValue("txtIGItem5");
		var IGItem6 = $.form.GetValue("txtIGItem6");
		var IGItem7 = $.form.GetValue("txtIGItem7");
		var IGItem8 = $.form.GetValue("txtIGItem8");
		var IGItem9 = $.form.GetValue("txtIGItem9");
		var IGItem10 = $.form.GetValue("txtIGItem10");
		var IGItem11 = $.form.GetValue("txtIGItem11");
		var IGItem12 = $.form.GetValue("txtIGItem12");
		var IGItem13 = $.form.GetValue("txtIGItem13");
		var IGItem14 = $.form.GetValue("txtIGItem14");
		var IGItem15 = $.form.GetValue("txtIGItem15");
		var IGItem16 = $.form.GetValue("txtIGItem16");
		var IGItem17 = $.form.GetValue("txtIGItem17");
		var IGItem18 = $.form.GetValue("txtIGItem18");
		var IGItem19 = $.form.GetValue("txtIGItem19");
		var IGItem20 = $.form.GetValue("txtIGItem20");
		var ActUserDr = $.LOGON.USERID;
		
		var type = /(^[0-9]\d*$)/;　　//正整数+0
		var ErrorStr="";
		if ((IGItem1!="")&&((!type.test(IGItem1))||(IGItem1>10000))){
			ErrorStr += "第一周A等级数据错误，请录入小于10000的0-9的数字！</br>";
		}
		if ((IGItem2!="")&&((!type.test(IGItem2))||(IGItem2>10000))){
			ErrorStr += "第一周B等级数据错误，请录入小于10000的0-9的数字！</br>";
		}
		if ((IGItem3!="")&&((!type.test(IGItem3))||(IGItem3>10000))){
			ErrorStr += "第一周C等级数据错误，请录入小于10000的0-9的数字！</br>";
		}
		if ((IGItem4!="")&&((!type.test(IGItem4))||(IGItem4>10000))){
			ErrorStr += "第一周D等级数据错误，请录入小于10000的0-9的数字！</br>";
		}
		if ((IGItem5!="")&&((!type.test(IGItem5))||(IGItem5>10000))){
			ErrorStr += "第一周E等级数据错误，请录入小于10000的0-9的数字！</br>";
		}
        if ((IGItem6!="")&&((!type.test(IGItem6))||(IGItem6>10000))){
			ErrorStr += "第二周A等级数据错误，请录入小于10000的0-9的数字！</br>";
		}
		if ((IGItem7!="")&&((!type.test(IGItem7))||(IGItem7>10000))){
			ErrorStr += "第二周B等级数据错误，请录入小于10000的0-9的数字！</br>";
		}
		if ((IGItem8!="")&&((!type.test(IGItem8))||(IGItem8>10000))){
			ErrorStr += "第二周C等级数据错误，请录入小于10000的0-9的数字！</br>";
		}
		if ((IGItem9!="")&&((!type.test(IGItem9))||(IGItem9>10000))){
			ErrorStr += "第二周D等级数据错误，请录入小于10000的0-9的数字！</br>";
		}
		if ((IGItem10!="")&&((!type.test(IGItem10))||(IGItem10>10000))){
			ErrorStr += "第二周E等级数据错误，请录入小于10000的0-9的数字！</br>";
		}
		if ((IGItem11!="")&&((!type.test(IGItem11))||(IGItem11>10000))){
			ErrorStr += "第三周A等级数据错误，请录入小于10000的0-9的数字！</br>";
		}
		if ((IGItem12!="")&&((!type.test(IGItem12))||(IGItem12>10000))){
			ErrorStr += "第三周B等级数据错误，请录入小于10000的0-9的数字！</br>";
		}
		if ((IGItem13!="")&&((!type.test(IGItem13))||(IGItem13>10000))){
			ErrorStr += "第三周C等级数据错误，请录入小于10000的0-9的数字！</br>";
		}
		if ((IGItem14!="")&&((!type.test(IGItem14))||(IGItem14>10000))){
			ErrorStr += "第三周D等级数据错误，请录入小于10000的0-9的数字！</br>";
		}
		if ((IGItem15!="")&&((!type.test(IGItem15))||(IGItem15>10000))){
			ErrorStr += "第三周E等级数据错误，请录入小于10000的0-9的数字！</br>";
		}
		if ((IGItem16!="")&&((!type.test(IGItem16))||(IGItem16>10000))){
			ErrorStr += "第四周A等级数据错误，请录入小于10000的0-9的数字！</br>";
		}
		if ((IGItem17!="")&&((!type.test(IGItem17))||(IGItem17>10000))){
			ErrorStr += "第四周B等级数据错误，请录入小于10000的0-9的数字！</br>";
		}
		if ((IGItem18!="")&&((!type.test(IGItem18))||(IGItem18>10000))){
			ErrorStr += "第四周C等级数据错误，请录入小于10000的0-9的数字！</br>";
		}
		if ((IGItem19!="")&&((!type.test(IGItem19))||(IGItem19>10000))){
			ErrorStr += "第四周D等级数据错误，请录入小于10000的0-9的数字！</br>";
		}
		if ((IGItem20!="")&&((!type.test(IGItem20))||(IGItem20>10000))){
			ErrorStr += "第四周E等级数据错误，请录入小于10000的0-9的数字！</br>";
		}
		if (ErrorStr !="") {
			layer.alert(ErrorStr,{icon: 0});
			return false;
		}
		var InputStr1 = ItemID1;
		InputStr1 += "^" + LocDr;
		InputStr1 += "^" + Year;
		InputStr1 += "^" + Month;
		InputStr1 += "^" + "1";
		InputStr1 += "^" + IGItem1;
		InputStr1 += "^" + IGItem2;
		InputStr1 += "^" + IGItem3;
		InputStr1 += "^" + IGItem4;
		InputStr1 += "^" + IGItem5;
		InputStr1 += "^" +"";
		InputStr1 += "^" +"";
		InputStr1 += "^" + ActUserDr;
		
		var InputStr2 = ItemID2;
		InputStr2 += "^" + LocDr;
		InputStr2 += "^" + Year;
		InputStr2 += "^" + Month;
		InputStr2 += "^" + "2";
		InputStr2 += "^" + IGItem6;
		InputStr2 += "^" + IGItem7;
		InputStr2 += "^" + IGItem8;
		InputStr2 += "^" + IGItem9;
		InputStr2 += "^" + IGItem10;
		InputStr2 += "^" +"";
		InputStr2 += "^" +"";
		InputStr2 += "^" + ActUserDr;
		
		var InputStr3 = ItemID3;
		InputStr3 += "^" + LocDr;
		InputStr3 += "^" + Year;
		InputStr3 += "^" + Month;
		InputStr3 += "^" + "3";
		InputStr3 += "^" + IGItem11;
		InputStr3 += "^" + IGItem12;
		InputStr3 += "^" + IGItem13;
		InputStr3 += "^" + IGItem14;
		InputStr3 += "^" + IGItem15;
		InputStr3 += "^" +"";
		InputStr3 += "^" +"";
		InputStr3 += "^" + ActUserDr;
		
		var InputStr4 = ItemID4;
		InputStr4 += "^" + LocDr;
		InputStr4 += "^" + Year;
		InputStr4 += "^" + Month;
		InputStr4 += "^" + "4";
		InputStr4 += "^" + IGItem16;
		InputStr4 += "^" + IGItem17;
		InputStr4 += "^" + IGItem18;
		InputStr4 += "^" + IGItem19;
		InputStr4 += "^" + IGItem20;
		InputStr4 += "^" +"";
		InputStr4 += "^" +"";
		InputStr4 += "^" + ActUserDr;
        var InputStr = InputStr1+"#"+InputStr2+"#"+InputStr3+"#"+InputStr4;
		var retval = $.Tool.RunServerMethod("DHCHAI.IRS.ICUGradeSrv","SaveRec",InputStr,"^");

		if (parseInt(retval)>0){
			obj.gridGrade.ajax.reload(function(){
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-1'){
				layer.alert('第一周数据保存失败!',{icon: 0});
			}else if(parseInt(retval)=='-2'){
				layer.alert('第二周数据保存失败!',{icon: 0});
			}else if(parseInt(retval)=='-3'){
				layer.alert('第三周数据保存失败!',{icon: 0});
			}else if(parseInt(retval)=='-4'){
				layer.alert('第四周数据保存失败!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
}