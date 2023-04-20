using UnityEngine;
using UnityEngine.Rendering;

namespace Chapter_14.World_Scan.Chapter_14___World_Scan
{
    public class Scanner : MonoBehaviour
    {
        [SerializeField] private Volume volume;
        
        public float scanSpeed;
        public float scanWidth;
        public Texture overlayRampTex;
        [ColorUsage(true, hdr:true)] public Color overlayColor;
        
        private WorldScanVolumeComponent _worldScan;
        private bool _isScanning;
        
        private void Start()
        {
            if(volume == null || volume.profile == null)
            {
                return;
            }

            volume.profile.TryGet(out _worldScan);
        }
        private void Update()
        {
            if(Input.GetButtonDown("Fire1"))
            {
                StartScan(transform.position);
            }
            else if(Input.GetButtonDown("Fire2"))
            {
                StopScan();
            }
            
            if(_isScanning)
            {
                UpdateScan();
            }
        }
        
        public void StartScan(Vector3 origin)
        {
            if (_worldScan == null) return;
            _isScanning = true;
            _worldScan.enabled.Override(true);
            _worldScan.overlayRampTex.Override(overlayRampTex);
            _worldScan.overlayColor.Override(overlayColor);
            _worldScan.scanWidth.Override(scanWidth);
            _worldScan.scanOrigin.Override(origin);
            _worldScan.scanDist.Override(0.0f);
        }

        public void UpdateScan()
        {
            if (_worldScan == null) return;
            _worldScan.scanDist.value += scanSpeed * Time.deltaTime;
        }

        public void StopScan()
        {
            if (_worldScan == null) return;
            _isScanning = false;
            _worldScan.enabled.Override(false);
        }
    }
}