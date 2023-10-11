var ZYZLAss_Scar=(function(){
	function Init(){
		PageHandle();
		
		
		if(ServerObj.DCAssRowId==""){
			//默认当前时间,设置最大日期为当天
			//assTempShow.js
			setDefAssDate('SCAR_Date');
		}
		//色泽 M
		$HUI.combobox("#SCAR_Color", {
			valueField: 'id',
			textField: 'text', 
			editable:false,
			enterNullValueClear:false,
			data: [
				{id:'0',text:$g('皮肤颜色与身体其他部份比较近似正常')},
				{id:'1',text:$g('色泽较浅')},{id:'2',text:$g('混合色泽')},
				{id:'3',text:$g('色泽较深')}
			]
		 });
		 
		 //血管分布 V
		 $HUI.combobox("#SCAR_BloVes", {
			valueField: 'id',
			textField: 'text', 
			editable:false,
			enterNullValueClear:false,
			data: [
				{id:'0',text:$g('正常肤色与身体其他部份近似')},
				{id:'1',text:$g('肤色偏粉红')},
				{id:'2',text:$g('肤色偏红')},
				{id:'3',text:$g('肤色呈紫色')}
			]
		 });
		 
		 //柔软度 P
		 $HUI.combobox("#SCAR_Soft", {
			valueField: 'id',
			textField: 'text', 
			editable:false,
			enterNullValueClear:false,
			data: [
				{id:'0',text:$g('正常')},
				{id:'1',text:$g('柔软的（在最少阻力下皮肤能变形的）')},
				{id:'2',text:$g('柔顺的（在压力下能变形的）')},
				{id:'3',text:$g('硬的（不能变形的，移动呈块状，对压力有阻力）')},
				{id:'4',text:$g('弯曲（组织如绳状，疤痕伸展时会退缩）')},
				{id:'5',text:$g('挛缩（疤痕永久性缩短引致残废与扭曲）')}
			]
		 });
		 
		 //厚度 H
		 $HUI.combobox("#SCAR_Thick", {
			valueField: 'id',
			textField: 'text', 
			editable:false,
			enterNullValueClear:false,
			data: [
				{id:'0',text:$g('正常')},
				{id:'1',text:$g('=/>0至1mm')},
				{id:'2',text:$g('>1至2mm毫米比例')},
				{id:'3',text:$g('>2至4mm')},
				{id:'4',text:'>4mm'}
			]
		 });
		 
		$HUI.combobox("input[comboname^='Score']",{
			onChange:function(newvalue,oldvalue){
			    TakCalScore(newvalue,oldvalue);
			}
		});
	}
	
	function PageHandle(){
		/*$(".panel-body .panel").css({
			"margin-bottom":"0px"
		})
		$("#ZYZLAss_Scar").css({
			"margin":"10px 0px"
		})
		
		$(".item-table-line tr:last-child td").css({
			"border-bottom":"none"
		})

		$("#ZYZLAss_Scar").panel("resize",{height:79})	
		*/
	}
	
	function TakCalScore(newvalue,oldvalue){
		var Score=$("#SCAR_Score").val();
		if(Score==""){Score=0}
		if(oldvalue==""){oldvalue=0}
		var TotalScore=parseInt(Score)+parseInt(newvalue)-parseInt(oldvalue)
		$("#SCAR_Score").val(TotalScore)
	}
	
	function OtherInfo(){
		return ""
	}
	function PrintInfo(){
		return ""
	}
	return {
		"Init":Init,
		"OtherInfo":OtherInfo,
		"PrintInfo":PrintInfo,
	}
})();