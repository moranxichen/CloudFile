using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;

public class ShaderCheckTool : EditorWindow
{


    public Object checkShader ;
    //private Shader checkShader;


    [MenuItem("Tools/ShaderCheckTool")]

    static void Toolswindow()
    {
        ShaderCheckTool window = (ShaderCheckTool)EditorWindow.GetWindow(typeof(ShaderCheckTool));
        window.Show();
    }

    public static string shadername;
    private void OnGUI()
    {
        GUILayout.Label("About shader", EditorStyles.boldLabel);
        //EditorGUILayout.BeginHorizontal();
        checkShader = EditorGUILayout.ObjectField(label:"SelectShader", checkShader, typeof(Object), true);
        shadername = checkShader.ToString();

        if (GUILayout.Button("Check")){
            shadername = shadername.Replace("(UnityEngine.Shader)","");
            shadername = shadername.Trim();
            

            Listmat();
            Write();
            Debug.Log("写入成功,写入到"+ Application.dataPath + "/MateCheckPath.txt");
            Debug.Log(MaterialPath.Count);
            Debug.Log(path01);
        }

    }

    public static List<string> MaterialPath = new List<string>();
    public static List<Material> Shadermat = new List<Material>();
    public string path01;

    static void Listmat()
    {
        string path = Application.dataPath;
        //string[] ss = Directory.GetFiles(path, "*.mat", SearchOption.AllDirectories);
        //for (int i = 0; i < ss.Length; i++)
        //{
        //    MaterialPath.Add(ss[i]);
        //}
        MaterialPath = new List<string>(Directory.GetFiles(path, "*.mat", SearchOption.AllDirectories));
        for (int i = 0; i < MaterialPath.Count; i++)
        {

            //去掉数组了的全部文件名Assets之前的部分
            string st = MaterialPath[i];
            //用/将字符串隔开 分成4个数组
            string[] sArray = st.Split('/');
            string path01 = sArray[4];

            Material[] m_material = new Material[MaterialPath.Count];
            //通过包含路径的文件名 将所有的材质球load出来
            m_material[i] = AssetDatabase.LoadAssetAtPath<Material>(path01);

            if (m_material[i].shader == Shader.Find(shadername))
            {
                Shadermat.Add(m_material[i]);
            }
            else
            {
                Debug.Log("没有找到相关mat");
            }
        }
    }
    public void Write()

    {
        FileStream matTxt = new FileStream(Application.dataPath + "/MateCheckPath.txt", FileMode.Create);

        StreamWriter matTxtStreamWriter = new StreamWriter(matTxt);


        matTxtStreamWriter.Write(shadername);

        matTxtStreamWriter.Flush();
        matTxtStreamWriter.Close();
        matTxt.Close();

    }

}
