Class EMR.DOC.DTO.Resource Extends %RegisteredObject
{

/// 项目标识
Property Product As %String;

/// 名称
Property Name As %String(TRUNCATE = 1);

/// 标题
Property Title As %String(TRUNCATE = 1);

/// frame名
Property Frame As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 关联配置
Property Content As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 链接
Property Href As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 顺序
Property Position As %Integer;

/// N：不显示； Window：在弹出的资源区内显示； Panel：在主页面的资源区中显示
Property Visible As %String(TRUNCATE = 1);

/// 缩放比例 数字 如90；不缩放则为空
Property Zoom As %String;

/// 滚动条 yes / no; 默认为空，则为no
Property Scrolling As %String;

/// 切换过来的时候，是否刷新 Y为刷新，其他值为不刷新
Property RefreshOnSelect As %String;

}
