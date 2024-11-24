using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class lightContral : MonoBehaviour
{
    public Light light;
    public Vector3 offset;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        // 获取光源的原始位置
            Vector3 originalPosition = light.transform.position;
            // offset.x+=Time.deltaTime/100%1;
            // offset.z+=Time.deltaTime/100%1;
        // 应用偏移量
        // 
            light.transform.position =  originalPosition +offset;

        
    }
}
