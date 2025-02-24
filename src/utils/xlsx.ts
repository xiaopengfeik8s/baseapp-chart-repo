import XLSX, { writeFile } from 'xlsx-js-style';

interface SheetParams {
  fileName: string;
  sheetName?: string;
  header: string[];
  dataList: any[][];
  callback?: (worksheet: XLSX.WorkSheet) => void;
}

export const downloadSheet = (params: SheetParams) => {
  const workbook = XLSX.utils.book_new();
  const sheetName = params.sheetName || params.fileName;
  const worksheetData = [params.header, ...params.dataList];
  const worksheet = XLSX.utils.aoa_to_sheet(worksheetData);
  XLSX.utils.book_append_sheet(workbook, worksheet, sheetName);
  // eslint-disable-next-line @typescript-eslint/no-unused-expressions
  params.callback && params.callback(worksheet);
  writeFile(workbook, `${params.fileName}.xlsx`);
};

interface SheetItem {
  sheetName: string;
  header: string[];
  dataList: any[][];
  callback?: (worksheet: XLSX.WorkSheet) => void;
}
interface MultiSheetParams {
  fileName: string;
  sheetList: SheetItem[];
}

export const downloadMultiSheet = (params: MultiSheetParams) => {
  const workbook = XLSX.utils.book_new();
  params.sheetList.forEach((sheetItem) => {
    const sheetName = sheetItem.sheetName || params.fileName;
    const worksheetData = [sheetItem.header, ...sheetItem.dataList];
    const worksheet = XLSX.utils.aoa_to_sheet(worksheetData);
    XLSX.utils.book_append_sheet(workbook, worksheet, sheetName);
    // eslint-disable-next-line @typescript-eslint/no-unused-expressions
    sheetItem.callback && sheetItem.callback(worksheet);
  });
  writeFile(workbook, `${params.fileName}.xlsx`);
};

export const downloadTableSheet = (params: { fileName: string }) => {
  const table = document.getElementById('Table2XLSX');
  const workbook = XLSX.utils.table_to_book(table);

  writeFile(workbook, `${params.fileName}.xlsx`);
};
