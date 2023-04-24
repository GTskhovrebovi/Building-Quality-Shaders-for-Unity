using UnityEngine;

namespace Chapter_14.Interactive_Snow
{
    public class SnowActor : MonoBehaviour
    {
        public Vector3 groundOffset;
        
        private CapsuleCollider _capsuleCollider;
        private Vector3 _lastFramePos = Vector3.zero;

        public bool IsMoving { get; private set; }

        private void Start()
        {
            _capsuleCollider = GetComponent<CapsuleCollider>();
        }
        
        public Vector3 GroundPosition => transform.position + groundOffset;
        
        public float GetRadius()
        {
            var localScale = transform.localScale;
            var scaleRadius = Mathf.Max(localScale.x, localScale.z);
            return _capsuleCollider.radius * scaleRadius;
        }
        
        private void Update()
        {
            IsMoving = (transform.position != _lastFramePos);
            _lastFramePos = transform.position;
        }
    }
}