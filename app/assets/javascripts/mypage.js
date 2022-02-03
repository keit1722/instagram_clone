//= require jquery3
//= require popper
//= require rails-ujs
//= require bootstrap-material-design/dist/js/bootstrap-material-design.js

// 画像のプレビュー機能
function previewFileWithId(selector) {
  // inputタグを取得して変数targetに代入
  const target = this.event.target;
  // 画像ファイルの情報を取得して変数fileに代入。inputタグの属性であるfiles属性にアクセスしている。[0]はRubyと同じでfilesは配列なので1番目を指している。
  const file = target.files[0];
  // ファイルの内容を読み込むことができる便利なクラス、FileReaderクラス、のインスタンスを作成
  const reader = new FileReader();
  // FileReaderクラスのインスタンスにより画像ファイルの情報が読み込まれたら（正常に読み込まれた場合に発火するonloadとは少し違う）、
  // reviewFileWithIdが呼び出されたときの引数で渡されたimgタグに画像ファイルの情報を代入（resultプロパティに格納されている）。
  // ちなみにonloadedは非同期処理なので、下のif文がtrueのときにreaderが読み込まれた後に発火する。
  reader.onloadend = function () {
    selector.src = reader.result;
  };
  if (file) {
    // もしファイル情報があればFileReaderクラスのインスタンスに今回読み込んだファイルのバス情報をセット
    reader.readAsDataURL(file);
  } else {
    // もしファイル情報があればimgタグの画像を空にする
    // なんらかの原因で画像ファイルが読み込まれなかったときの処置
    selector.src = "";
  }
}
