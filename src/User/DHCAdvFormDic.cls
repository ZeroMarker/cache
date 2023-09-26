/// 表单元素字典表
/// zhouxin
/// 2017-09-20
Class User.DHCAdvFormDic Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHC_AdvFormDic ]
{

// 表单列名称，保存的实体类名称.列名称	

Property field As %String(MAXLEN = 2000);

// 样式名称

// easyui-combobox

// easyui-datebox

// input

// panel

// radio

// checkbox

// radio-input

// checkbox-input

// radio-select

// checkbox-select

// textarea

// datagrid

// tab

Property style As %String;

// 列标题

Property title As %String(MAXLEN = 2000);

// url

Property url As %String(MAXLEN = 200);

// 父节点

Property parRef As %String [ InitialExpression = 0 ];

// 默认值

Property value As %String(MAXLEN = 200);

// 换行 

// Y:换行

// 其他:不换行

Property newLine As %String;

// 宽度

Property width As %String [ InitialExpression = 171 ];

// 高度

Property height As %String [ InitialExpression = 20 ];

// textare 的col

Property cols As %String [ InitialExpression = 100 ];

// textare 的 rows

Property textarerows As %String [ InitialExpression = 5 ];

// 子元素和父元素关系

Property sameLevel As %String;

// 隐藏值

Property hiddenValue As %String(MAXLEN = 200);

// 子元素是否默认影藏

Property hiddenSub As %String;

// 字典分类

Property cat As %String;

// Y:字典子元素和父元素同行

// 其他子元素和父元素换行

Property subDicSameLine As %String;

// Y:可以复制

// 其他：不能复制

Property canCopy As %String;

// Y:显示title

// 其他：不显示title

Property displayTitle As %String;

// 排序

Property seq As %String [ InitialExpression = 0 ];

// 医院用户是否可以编辑

Property userEdit As %String;

// select-change 是否隐藏

// Y:隐藏

Property hidden As %String;

// Y:字典子元素走平铺 非百分比 

// 其他子元素走百分比  hxy 2018-06-06

Property subDicTile As %String;

Storage Default
{
<Data name="DHCAdvFormDicDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>field</Value>
</Value>
<Value name="3">
<Value>style</Value>
</Value>
<Value name="4">
<Value>title</Value>
</Value>
<Value name="5">
<Value>url</Value>
</Value>
<Value name="6">
<Value>parRef</Value>
</Value>
<Value name="7">
<Value>value</Value>
</Value>
<Value name="8">
<Value>newLine</Value>
</Value>
<Value name="9">
<Value>code</Value>
</Value>
<Value name="10">
<Value>width</Value>
</Value>
<Value name="11">
<Value>height</Value>
</Value>
<Value name="12">
<Value>cols</Value>
</Value>
<Value name="13">
<Value>textarerows</Value>
</Value>
<Value name="14">
<Value>cat</Value>
</Value>
<Value name="15">
<Value>sameLevel</Value>
</Value>
<Value name="16">
<Value>hiddenValue</Value>
</Value>
<Value name="17">
<Value>hiddenSub</Value>
</Value>
<Value name="18">
<Value>subDicSameLine</Value>
</Value>
<Value name="19">
<Value>canCopy</Value>
</Value>
<Value name="20">
<Value>displayTitle</Value>
</Value>
<Value name="21">
<Value>seq</Value>
</Value>
<Value name="22">
<Value>userEdit</Value>
</Value>
<Value name="23">
<Value>hidden</Value>
</Value>
<Value name="24">
<Value>subDicTile</Value>
</Value>
</Data>
<DataLocation>^User.DHCAdvFormDicD</DataLocation>
<DefaultData>DHCAdvFormDicDefaultData</DefaultData>
<IdLocation>^User.DHCAdvFormDicD</IdLocation>
<IndexLocation>^User.DHCAdvFormDicI</IndexLocation>
<StreamLocation>^User.DHCAdvFormDicS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

// field 索引

Index IndexField On field As AlphaUp;

// 父节点索引

Index IndexParef On parRef;

Method ToHTML(formItm = "")
{
	 	s id=+..%Id()
		s style=..style
		s title=..title
		s field=..field
		s dataAdd=""
		i +formItm'=0 d
		.s dataAdd=##class(web.DHCADVFormDic).getSubDic(formItm,id,dataAdd)

		w "<div class='box box-element' data-id="_id_" data-formItmId="_formItm_" >"
		w "<span class='drag label label-success' onclick='editPro("_id_","_+formItm_",this)'><i class='glyphicon glyphicon-chevron-down' ></i>属性</span>"
		w "		<a href='#close' class='remove label label-danger'><i class='glyphicon glyphicon-remove'></i> 删除</a>"
		w "		<span class='drag label label-primary'><i class='glyphicon glyphicon-move'></i> 拖动</span>"
		w "		<div class='preview' title='"_title_"("_style_")'>"_title_"<span class='label label-danger'>("_style_")</span></div>"
		w "		<div class='view'>"
		
		w " <label class='col-sm-12' data-id="_id_" data-add='"_dataAdd_"'>"_title_"/"_field_"("_style_")"
	
		w "		</div>"
		w "</div>"
}

/// 分类索引
Index IndexCat On cat;

Index IndexTitle On title;

/// 按顺序显示子元素
Index IndexSeq On (parRef, seq As Plus);

}
