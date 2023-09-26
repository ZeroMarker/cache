function InitFPMainInfo(obj){
    obj.FPM_InitView = function(){
		obj.FPM_Editor = new Object();
		obj.arryFPMData = new Array();
		obj.FPM_Editor.Items = new Array();
		var ret=obj.FPM_LoadFPQuery();
		
		obj.FPM_FPTemplate.overwrite("divMainIfno-FP",obj.arryFPMData);
		obj.FPS_FPTemplate.overwrite("divSubIfno-FP",obj.arryFPMData);
		obj.FPM_CreatEditorItems(obj.arryFPMData);  //创建附加项目编辑单元
	}
	
	obj.FPM_LoadFPQuery = function(){
		var conn = Ext.lib.Ajax.getConnectionObject().conn;
		var url = ExtToolSetting.RunQueryPageURL + '?1=1'
		url += '&ClassName=' + 'DHCWMR.FP.ExtraItem'
		url += '&QueryName=' + 'QryExtraItem'
		url += '&ArgCnt=' + 0
		url += '&2=2'
		conn.open('post',url,false);
		conn.send(null);
		
		if (conn.status != '200') {
			ExtTool.alert('错误', '查询Query报错1!');
			return false;
		}
		
		var jsonData = new Ext.decode(conn.responseText);
		if (jsonData.total < 1){
			ExtTool.alert('查询Query报错2!');
			return false;
		} else {
			var arryData = new Array();
			var objItem = null;
			for (var row = 0; row < jsonData.record.length; row++){
				objItem = jsonData.record[row];
				arryData[arryData.length] = objItem;
			}
			obj.arryFPMData.length = 0;
			obj.arryFPMData = arryData;
				
			return true;
		}
		
	/* 	Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL,
			method : "POST",
			params  : {
				ClassName : 'DHCWMR.FP.ExtraItem',
				QueryName : 'QryExtraItem',
				ArgCnt : 0
			},
			success: function(response, opts) {
				var objData = Ext.decode(response.responseText);
				var arryData = new Array();
				var objItem = null;
				for(var i = 0; i < objData.total; i ++)
				{
					objItem = objData.record[i];
					if (objItem.ItemCode.indexOf("FPM")>-1) arryData[arryData.length] = objItem;
				}
				obj.arryFPMData.length = 0;
				obj.arryFPMData = arryData;
				
				return true;
				
			},
			failure: function(response, opts) {
				ExtTool.alert("提示","主要数据信息加载错误!");
				return false;
			}
		}); */
	}
	
	obj.FPM_FPTemplate = new Ext.XTemplate(
		'<table id="tableMainInfo_FP" border=0 cellpadding=0 cellspacing=0 style="border-collapse:collapse;color:#457294;text-align:center;width:100%;">',
			'<tbody>',
				'<tr><td width="100%"><div style="width=100%;padding:0px 10px;">',
					'<table><tr>',
						'<td><div class="TD-title">医疗付费方式</div></td><td><div class="TD-content" {[this.divStyle("P00020000")]}></div></td>',
						'<td><div class="TD-title"></div></td><td><div class="TD-content" ></div></td>',
						'<td><div class="TD-title"></div></td><td><div class="TD-content" ></div></td>',
						'<td><div class="TD-title"></div></td><td><div class="TD-content" ></div></td>',
						'<td><div class="TD-title"></div></td><td><div class="TD-content" ></div></td>',
					'</tr></table>',
					'<table><tr>',
						'<td><div class="TD-title">健康卡号</div></td><td><div class="TD-content" {[this.divStyle("P00030000")]}></div></td>',
						'<td><div class="TD-title">住院次数</div></td><td><div class="TD-content" {[this.divStyle("P00040000")]}></div></td>',
						'<td><div class="TD-title">病案号</div></td><td><div class="TD-content" {[this.divStyle("P00050000")]}></div></td>',
						'<td><div class="TD-title"></div></td><td><div class="TD-content" ></div></td>',
						'<td><div class="TD-title"></div></td><td><div class="TD-content" ></div></td>',
					'</tr></table>',
					'<table><tr>',
						'<td><div class="TD-title">姓名</div></td><td><div class="TD-content" {[this.divStyle("P00060000")]}></div></td>',
						'<td><div class="TD-title">性别</div></td><td><div class="TD-content" {[this.divStyle("P00070000")]}></div></td>',
						'<td><div class="TD-title">出生日期</div></td><td><div class="TD-content" {[this.divStyle("P00080000")]}></div></td>',
						'<td><div class="TD-title">年龄</div></td><td><div class="TD-content" {[this.divStyle("P00090000")]}></div></td>',
						'<td><div class="TD-title">国籍</div></td><td><div class="TD-content" {[this.divStyle("P00100000")]}></div></td>',
					'</tr></table>',
					'<table><tr>',
						'<td><div class="TD-title">年龄(不足1周岁)</div></td><td><div class="TD-content" {[this.divStyle("P00090100")]}></div></td>',
						'<td><div class="TD-title">新生儿出生体重</div></td><td><div class="TD-content" {[this.divStyle("P00110000")]}></div></td>',
						'<td><div class="TD-title">新生儿入院体重</div></td><td><div class="TD-content" {[this.divStyle("P00120000")]}></div></td>',
						'<td><div class="TD-title" style="text-align:left;">(体重单位：克)</div></td><td><div class="TD-content" ></div></td>',
						'<td><div class="TD-title"></div></td><td><div class="TD-content" ></div></td>',
					'</tr></table>',
					'<table><tr>',
						'<td><div class="TD-title">出生地：省</div></td><td><div class="TD-content" {[this.divStyle("P00130100")]}></div></td>',
						'<td><div class="TD-title">市(地区、州)</div></td><td><div class="TD-content" {[this.divStyle("P00130200")]}></div></td>',
						'<td><div class="TD-title">县(区)</div></td><td><div class="TD-content" {[this.divStyle("P00130300")]}></div></td>',
						'<td><div class="TD-title">籍贯：省</div></td><td><div class="TD-content" {[this.divStyle("P00140100")]}></div></td>',
						'<td><div class="TD-title">市(地区、州)</div></td><td><div class="TD-content" {[this.divStyle("P00140200")]}></div></td>',
					'</tr></table>',
					'<table><tr>',
						'<td><div class="TD-title">民族</div></td><td><div class="TD-content" {[this.divStyle("P00150000")]}></div></td>',
						'<td><div class="TD-title">身份证号</div></td><td><div class="TD-content" {[this.divStyle("P00160000")]}></div></td>',
						'<td><div class="TD-title">职业</div></td><td><div class="TD-content" {[this.divStyle("P00170000")]}></div></td>',
						'<td><div class="TD-title">婚姻</div></td><td><div class="TD-content" {[this.divStyle("P00180000")]}></div></td>',
						'<td><div class="TD-title">电话</div></td><td><div class="TD-content" {[this.divStyle("P00190500")]}></div></td>',
					'</tr></table>',
					'<table><tr>',
						'<td><div class="TD-title">现住址：省</div></td><td><div class="TD-content" {[this.divStyle("P00190100")]}></div></td>',
						'<td><div class="TD-title">市(地区、州)</div></td><td><div class="TD-content" {[this.divStyle("P00190200")]}></div></td>',
						'<td><div class="TD-title">县(区)</div></td><td><div class="TD-content" {[this.divStyle("P00190300")]}></div></td>',
						'<td><div class="TD-title">详细</div></td><td><div class="TD-content" {[this.divStyle("P00190400")]}></div></td>',
						'<td><div class="TD-title">邮政编码</div></td><td><div class="TD-content" {[this.divStyle("P00190600")]}></div></td>',
					'</tr></table>',
					'<table><tr>',
						'<td><div class="TD-title">户口地址：省</div></td><td><div class="TD-content" {[this.divStyle("P00200100")]}></div></td>',
						'<td><div class="TD-title">市(地区、州)</div></td><td><div class="TD-content" {[this.divStyle("P00200200")]}></div></td>',
						'<td><div class="TD-title">县(区)</div></td><td><div class="TD-content" {[this.divStyle("P00200300")]}></div></td>',
						'<td><div class="TD-title">详细</div></td><td><div class="TD-content" {[this.divStyle("P00200400")]}></div></td>',
						'<td><div class="TD-title">邮政编码</div></td><td><div class="TD-content" {[this.divStyle("P00200500")]}></div></td>',
					'</tr></table>',
					'<table><tr>',
						'<td><div class="TD-title">工作单位及地址</div></td><td><div class="TD-Longcontent" {[this.divStyle("P00210000")]}></div></td>',
						'<td><div class="TD-title">电话</div></td><td><div class="TD-content" {[this.divStyle("P00210100")]}></div></td>',
						'<td><div class="TD-title">邮政编码</div></td><td><div class="TD-content" {[this.divStyle("P00210200")]}></div></td>',
					'</tr></table>',
					'<table><tr>',
						'<td><div class="TD-title">联系人姓名</div></td><td><div class="TD-content" {[this.divStyle("P00220000")]}></div></td>',
						'<td><div class="TD-title">与患者关系</div></td><td><div class="TD-content" {[this.divStyle("P00220100")]}></div></td>',
						'<td><div class="TD-title">地址</div></td><td><div class="TD-content" {[this.divStyle("P00220200")]}></div></td>',
						'<td><div class="TD-title">电话</div></td><td><div class="TD-content" {[this.divStyle("P00220300")]}></div></td>',
						'<td><div class="TD-title">入院途径</div></td><td><div class="TD-content" {[this.divStyle("P00230000")]}></div></td>',
					'</tr></table>',
					'<table><tr>',
						'<td><div class="TD-title">入院日期</div></td><td><div class="TD-content" {[this.divStyle("P00250000")]}></div></td>',
						'<td><div class="TD-title">入院科别</div></td><td><div class="TD-content" {[this.divStyle("P00260000")]}></div></td>',
						'<td><div class="TD-title">病房</div></td><td><div class="TD-content" {[this.divStyle("P00270000")]}></div></td>',
						'<td><div class="TD-title">转科</div></td><td><div class="TD-content" {[this.divStyle("P00280000")]}></div></td>',
						'<td><div class="TD-title">血型</div></td><td><div class="TD-content" {[this.divStyle("P00570000")]}></div></td>',
					'</tr></table>',
					'<table><tr>',
						'<td><div class="TD-title">出院日期</div></td><td><div class="TD-content" {[this.divStyle("P00290000")]}></div></td>',
						'<td><div class="TD-title">出院科别</div></td><td><div class="TD-content" {[this.divStyle("P00300000")]}></div></td>',
						'<td><div class="TD-title">病房</div></td><td><div class="TD-content" {[this.divStyle("P00310000")]}></div></td>',
						'<td><div class="TD-title">住院天数</div></td><td><div class="TD-content" {[this.divStyle("P00320000")]}></div></td>',
						'<td><div class="TD-title">Rh</div></td><td><div class="TD-content" {[this.divStyle("P00580000")]}></div></td>',
					'</tr></table>',
					 '<table><tr>',
						'<td><div class="TD-title">是否药物过敏</div></td><td><div class="TD-content" {[this.divStyle("P00510000")]}></div></td>',
						'<td><div class="TD-title">过敏药物</div></td><td><div class="TD-Longcontent" {[this.divStyle("P00520000")]}></div></td>',
						'<td><div class="TD-title">死亡患者尸检</div></td><td><div class="TD-content" {[this.divStyle("P00530000")]}></div></td>',
					'</tr></table>',
					'<table><tr>',
						'<td><div class="TD-title">科主任</div></td><td><div class="TD-content" {[this.divStyle("P00600100")]}></div></td>',
						'<td><div class="TD-title">(副)主任医师</div></td><td><div class="TD-content" {[this.divStyle("P00600200")]}></div></td>',
						'<td><div class="TD-title">主治医师</div></td><td><div class="TD-content" {[this.divStyle("P00600300")]}></div></td>',
						'<td><div class="TD-title">住院医师</div></td><td><div class="TD-content" {[this.divStyle("P00600400")]}></div></td>',
						'<td><div class="TD-title"></div></td><td><div class="TD-content" ></div></td>',
					'</tr></table>',
					'<table><tr>',
						'<td><div class="TD-title">责任护士</div></td><td><div class="TD-content" {[this.divStyle("P00600500")]}></div></td>',
						'<td><div class="TD-title">进修医师</div></td><td><div class="TD-content" {[this.divStyle("P00600600")]}></div></td>',
						'<td><div class="TD-title">实习医师</div></td><td><div class="TD-content" {[this.divStyle("P00600800")]}></div></td>',
						'<td><div class="TD-title">编码员</div></td><td><div class="TD-content" {[this.divStyle("P00600900")]}></div></td>',
						'<td><div class="TD-title"></div></td><td><div class="TD-content" ></div></td>',
					'</tr></table>',
					'<table><tr>',
						'<td><div class="TD-title">病案质量</div></td><td><div class="TD-content" {[this.divStyle("P00610000")]}></div></td>',
						'<td><div class="TD-title">质控医师</div></td><td><div class="TD-content" {[this.divStyle("P00610100")]}></div></td>',
						'<td><div class="TD-title">质控护士</div></td><td><div class="TD-content" {[this.divStyle("P00610200")]}></div></td>',
						'<td><div class="TD-title">日期</div></td><td><div class="TD-content" {[this.divStyle("P00610300")]}></div></td>',
						'<td><div class="TD-title"></div></td><td><div class="TD-content" ></div></td>',
					'</tr></table>', 
					'<table><tr>',
						'<td><div class="TD-title">离院方式</div></td><td><div class="TD-content" {[this.divStyle("P00620000")]}></div></td>',
						'<td><div class="TD-title">转入医疗机构</div></td><td><div class="TD-content" {[this.divStyle("P00620100")]}></div></td>',
						'<td><div class="TD-title">接收社区名称</div></td><td><div class="TD-content" {[this.divStyle("P00620200")]}></div></td>',
						'<td><div class="TD-title">31天内再住院</div></td><td><div class="TD-content" {[this.divStyle("P00630000")]}></div></td>',
						'<td><div class="TD-title">目的</div></td><td><div class="TD-content" {[this.divStyle("P00630100")]}></div></td>',
					'</tr></table>', 
					'<table><tr>',
						'<td><div class="TD-title">脑颅损伤入院前</div></td><td><div class="TD-content1" {[this.divStyle("P00640001")]}></div></td>',
						'<td><div class="TD-title1">天</div></td><td><div class="TD-content1" {[this.divStyle("P00640002")]}></div></td>',
						'<td><div class="TD-title1">小时</div></td><td><div class="TD-content1" {[this.divStyle("P00640003")]}></div></td>',
						'<td><div class="TD-title1">分钟</div></td><td><div class="TD-content" ></div></td>',
						'<td><div class="TD-title"></div></td><td><div class="TD-content" ></div></td>',
					'</tr></table>',
					'<table><tr>',
						'<td><div class="TD-title">脑颅损伤入院后</div></td><td><div class="TD-content1" {[this.divStyle("P00650001")]}></div></td>',
						'<td><div class="TD-title1">天</div></td><td><div class="TD-content1" {[this.divStyle("P00650002")]}></div></td>',
						'<td><div class="TD-title1">小时</div></td><td><div class="TD-content1" {[this.divStyle("P00650003")]}></div></td>',
						'<td><div class="TD-title1">分钟</div></td><td><div class="TD-content" ></div></td>',
						'<td><div class="TD-title"></div></td><td><div class="TD-content" ></div></td>',
					'</tr></table>',
				'</div></td></tr>',	
			'</tbody>',
		'</table>',
		{
			divStyle : function(ItemCode){
				var tabEv = ''
				tabEv += ' id="Cmp_' + 'FPM_Editor_Item' + ItemCode + '"'
				//tabEv += ' style="width:100%;overflow:hidden;"'
				return tabEv;
			}
		}
	);
	
	
	obj.FPS_FPTemplate = new Ext.XTemplate(
		'<table id="tableSubInfo_FP" border=0 cellpadding=0 cellspacing=0 style="border-collapse:collapse;color:#457294;text-align:center;width:100%;">',
			'<tbody>',
				'<tr><td width="100%"><div style="width=100%;padding:0px 10px;">',
					 '<table><tr>',
						'<td><div class="TD-title">病例分型</div></td><td><div class="TD-content" {[this.divStyle("P90010000")]}></div></td>',
						'<td><div class="TD-title">医院感染</div></td><td><div class="TD-content" {[this.divStyle("P90051000")]}></div></td>',
						'<td><div class="TD-title">感染描述</div></td><td><div class="TD-Longcontent" {[this.divStyle("P90052000")]}></div></td>',
						'<td><div class="TD-title">传染病上报</div></td><td><div class="TD-content" {[this.divStyle("P90130000")]}></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td><div class="TD-title">输血反应</div></td><td><div class="TD-content" {[this.divStyle("P00590000")]}></div></td>',
						'<td><div class="TD-title">红细胞(单位)</div></td><td><div class="TD-content" {[this.divStyle("P00590100")]}></div></td>',
						'<td><div class="TD-title">血小板(袋)</div></td><td><div class="TD-content" {[this.divStyle("P00590200")]}></div></td>',
						'<td><div class="TD-title">血浆(ml)</div></td><td><div class="TD-content" {[this.divStyle("P00590300")]}></div></td>',
						'<td><div class="TD-title">自体回输(ml)</div></td><td><div class="TD-content" {[this.divStyle("P00590600")]}></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td><div class="TD-title">全血(ml)</div></td><td><div class="TD-content" {[this.divStyle("P00590400")]}></div></td>',
						'<td><div class="TD-title">其他(ml)</div></td><td><div class="TD-content" {[this.divStyle("P00590500")]}></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td style="color:#000000;text-align:left;background-color:#84C1FF;width:100%;"><div style="width=100%;"><span style="font-size:16px;">肿瘤相关信息</span></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td><div class="TD-title">肿瘤分期：T</div></td><td><div class="TD-content" {[this.divStyle("P00680101")]}></div></td>',
						'<td><div class="TD-title">N</div></td><td><div class="TD-content" {[this.divStyle("P00680102")]}></div></td>',
						'<td><div class="TD-title">M</div></td><td><div class="TD-content" {[this.divStyle("P00680103")]}></div></td>',
						'<td><div class="TD-title2">(0:0期,1:Ⅰ期,2:Ⅱ期,3:Ⅲ期,4:Ⅳ期,5:不详)</div></td><td><div class="TD-content" ></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td style="color:#000000;text-align:left;background-color:#84C1FF;width:100%;"><div style="width=100%;"><span style="font-size:16px;">抢救、临床路径信息</span></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td><div class="TD-title">抢救次数</div></td><td><div class="TD-content" {[this.divStyle("P00490000")]}></div></td>',
						'<td><div class="TD-title">成功次数</div></td><td><div class="TD-content" {[this.divStyle("P00500000")]}></div></td>',
						'<td><div class="TD-title">临床路径</div></td><td><div class="TD-content" {[this.divStyle("P90080000")]}></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td style="color:#000000;text-align:left;background-color:#84C1FF;width:100%;"><div style="width=100%;"><span style="font-size:16px;">重症监护信息</span></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td><div class="TD-title">重症监护室名1</div></td><td><div class="TD-content" {[this.divStyle("P50010100")]}></div></td>',
						'<td><div class="TD-title">进入时间1</div></td><td><div class="TD-content" {[this.divStyle("P50010200")]}></div></td>',
						'<td><div class="TD-title">出来时间1</div></td><td><div class="TD-content" {[this.divStyle("P50010300")]}></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td><div class="TD-title">重症监护室名2</div></td><td><div class="TD-content" {[this.divStyle("P50020100")]}></div></td>',
						'<td><div class="TD-title">进入时间2</div></td><td><div class="TD-content" {[this.divStyle("P50020200")]}></div></td>',
						'<td><div class="TD-title">出来时间2</div></td><td><div class="TD-content" {[this.divStyle("P50020300")]}></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td><div class="TD-title">重症监护室名3</div></td><td><div class="TD-content" {[this.divStyle("P50030100")]}></div></td>',
						'<td><div class="TD-title">进入时间3</div></td><td><div class="TD-content" {[this.divStyle("P50030200")]}></div></td>',
						'<td><div class="TD-title">出来时间3</div></td><td><div class="TD-content" {[this.divStyle("P50030300")]}></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td><div class="TD-title">是否使用呼吸机</div></td><td><div class="TD-content" {[this.divStyle("P90120000")]}></div></td>',
						'<td><div class="TD-title">使用时间</div></td><td><div class="TD-content" {[this.divStyle("P00670001")]}></div></td>',
						'<td><div class="TD-title">入院生活评分</div></td><td><div class="TD-content" {[this.divStyle("P90230000")]}></div></td>',
						'<td><div class="TD-title">出院院生活评分</div></td><td><div class="TD-content" {[this.divStyle("P90240000")]}></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td style="color:#000000;text-align:left;background-color:#84C1FF;width:100%;"><div style="width=100%;"><span style="font-size:16px;">新生儿多胎信息</span></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td><div class="TD-title">新生儿出生体重1</div></td><td><div class="TD-content" {[this.divStyle("P00110100")]}></div></td>',
						'<td><div class="TD-title">新生儿出生体重2</div></td><td><div class="TD-content" {[this.divStyle("P00110200")]}></div></td>',
						'<td><div class="TD-title">新生儿出生体重3</div></td><td><div class="TD-content" {[this.divStyle("P00110300")]}></div></td>',
						'<td><div class="TD-title" style="text-align:left;">(体重单位：克)</div></td><td><div class="TD-content" ></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td style="color:#000000;text-align:left;background-color:#84C1FF;width:100%;"><div style="width=100%;"><span style="font-size:16px;">诊断符合情况</span></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td><div class="TD-title">入院时情况</div></td><td><div class="TD-content" {[this.divStyle("P00380000")]}></div></td>',
						'<td><div class="TD-title">门诊与出院</div></td><td><div class="TD-content" {[this.divStyle("P00440000")]}></div></td>',
						'<td><div class="TD-title">入院与出院</div></td><td><div class="TD-content" {[this.divStyle("P00450000")]}></div></td>',
						'<td><div class="TD-title">术前与术后</div></td><td><div class="TD-content" {[this.divStyle("P00460000")]}></div></td>',
						'<td><div class="TD-title">临床与病理</div></td><td><div class="TD-content" {[this.divStyle("P00470000")]}></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td style="color:#000000;text-align:left;background-color:#84C1FF;width:100%;"><div style="width=100%;"><span style="font-size:16px;">同一病再入院</span></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td><div class="TD-title">确诊日期</div></td><td><div class="TD-content" {[this.divStyle("P00390000")]}></div></td>',
						'<td><div class="TD-title">是否15天内</div></td><td><div class="TD-content" {[this.divStyle("P90140000")]}></div></td>',
						'<td><div class="TD-title">是否30天内</div></td><td><div class="TD-content" {[this.divStyle("P90150000")]}></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td style="color:#000000;text-align:left;background-color:#84C1FF;width:100%;"><div style="width=100%;"><span style="font-size:16px;">手术附加信息</span></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td><div class="TD-title">手术名称1</div></td><td><div class="TD-content" {[this.divStyle("P90160600")]}></div></td>',
						'<td><div class="TD-title">手术类别1</div></td><td><div class="TD-content" {[this.divStyle("P90160100")]}></div></td>',
						'<td><div class="TD-title">手术持续时间1</div></td><td><div class="TD-content" {[this.divStyle("P90160200")]}></div></td>',
						'<td><div class="TD-title">手术患者类型1</div></td><td><div class="TD-content" {[this.divStyle("P90160300")]}></div></td>',
						'<td><div class="TD-title">麻醉分级1</div></td><td><div class="TD-content" {[this.divStyle("P90160400")]}></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td><div class="TD-title">手术名称2</div></td><td><div class="TD-content" {[this.divStyle("P90170600")]}></div></td>',
						'<td><div class="TD-title">手术类别2</div></td><td><div class="TD-content" {[this.divStyle("P90170100")]}></div></td>',
						'<td><div class="TD-title">手术持续时间2</div></td><td><div class="TD-content" {[this.divStyle("P90170200")]}></div></td>',
						'<td><div class="TD-title">手术患者类型2</div></td><td><div class="TD-content" {[this.divStyle("P90170300")]}></div></td>',
						'<td><div class="TD-title">麻醉分级2</div></td><td><div class="TD-content" {[this.divStyle("P90170400")]}></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td><div class="TD-title">手术名称3</div></td><td><div class="TD-content" {[this.divStyle("P90180600")]}></div></td>',
						'<td><div class="TD-title">手术类别3</div></td><td><div class="TD-content" {[this.divStyle("P90180100")]}></div></td>',
						'<td><div class="TD-title">手术持续时间3</div></td><td><div class="TD-content" {[this.divStyle("P90180200")]}></div></td>',
						'<td><div class="TD-title">手术患者类型3</div></td><td><div class="TD-content" {[this.divStyle("P90180300")]}></div></td>',
						'<td><div class="TD-title">麻醉分级3</div></td><td><div class="TD-content" {[this.divStyle("P90180400")]}></div></td>',
					'</tr></table>', 
				'</div></td></tr>',
			'</tbody>',
		'</table>',
		{
			divStyle : function(ItemCode){
				var tabEv = ''
				tabEv += ' id="Cmp_' + 'FPM_Editor_Item' + ItemCode + '"'
				//tabEv += ' style="width:100%;overflow:hidden;"'
				return tabEv;
			}
		}
	);
	
	
	obj.FPM_CreatEditorItems = function(arrItem){
		obj.FPM_Editor.Items.length = 0;
		var cmpName = 'FPM_Editor_Item';
		var itemId = '',itemDesc = '',itemValue = '',itemText = '';
		
		for (var ind = 0; ind < arrItem.length; ind++){
			var objItem = arrItem[ind];
			itemId = cmpName + objItem.ItemCode;
			itemDesc = objItem.ItemDesc;
			
			if (objItem.TypeCode == 'D'){
				var objCmp = FP_ComboDic(itemId,itemDesc,objItem.DicCode);
			} else if (objItem.TypeCode == 'T'){
				var objCmp = FP_TextField(itemId,itemDesc);
			} else if (objItem.TypeCode == 'N'){
				var objCmp = FP_NumberField(itemId,itemDesc);
			} else if (objItem.TypeCode == 'DD'){
				var objCmp = FP_DateField(itemId,itemDesc);
			} else {
				continue;
			}
			obj.FPM_Editor.Items.push(objCmp);
		}
		
		obj.FPM_GetDataFromEpr(obj.FPM_Editor.Items)
	}
	obj.FPM_GetDataFromEpr = function(arrItem){
		var conn = Ext.lib.Ajax.getConnectionObject().conn;
		var url = ExtToolSetting.RunQueryPageURL + '?1=1'
		url += '&ClassName=' + 'DHCWMR.FPService.FrontPageGet'
		url += '&QueryName=' + 'QryFrontPageInfo'
		url += '&Arg1=' + obj.FrontPage.FrontPageID
		url += '&Arg2=' + obj.FrontPage.VolumeID
		url += '&ArgCnt=' + 2
		url += '&2=2'
		conn.open('post',url,false);
		conn.send(null);
		
		if (conn.status != '200') {
			ExtTool.alert('错误', '查询Query报错3!');
			return false;
		}
		
		var jsonData = new Ext.decode(conn.responseText);
		if (jsonData.total < 1){
			ExtTool.alert('临床数据未同步!');
			//return false;
		} else {
			var arryData = new Array();
			var objData = null;
			for (var row = 0; row < jsonData.record.length; row++){
				objData = jsonData.record[row];
				var Datakey = 'FPM_Editor_Item'+objData.DataCode;
				arryData[Datakey] = objData.DataValue;
			}
			
			for (var ind = 0; ind < arrItem.length; ind++){
				var objItem = arrItem[ind];
				var tmpID=objItem.id;
				var tmpValue=arryData[tmpID];
				Common_SetValue(tmpID,tmpValue,tmpValue);
			}
		}
	}
	
	obj.FPM_GetEditData = function(arrItem) {
		var DataStr='EpisodeID' + CHR_2 + VolPaadm;
		for (var ind = 0; ind < arrItem.length; ind++){
			var objItem = arrItem[ind];
			var tmpID=objItem.id;
			var tmpCode=tmpID.split("_Item")[1];
			var tmpvalue=Common_GetText(tmpID);
			DataStr = DataStr + CHR_1 + tmpCode + CHR_2 + tmpvalue;
		}
		return DataStr;
	}
}